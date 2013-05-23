Entity ErleMul is
	Generic (n: positive := 5);
	Port (A,B: in bit_vector (4*n-1 downto 0);
		strt,clk: in bit;
		P: out bit_vector (8*n-1 downto 0));
End Entity;

architecture stuct of ErleMul is
component FA
	port (a,b,c: in bit;
		sum,carry: out bit);
end component;

component reg is
	generic (n: positive :=5);
	port (i:in bit_vector(n-1 downto 0);
		o:out bit_vector(n-1 downto 0);
		clk,reset,enable: in bit);
end component;
component RShreg is
	generic (d: positive :=10; -- number of stages
		w: positive := 4); -- input width
	port (pl:in bit_vector((w)*(d)-1 downto 0);
		i:in bit_vector(w-1 downto 0);
		o:out bit_vector(w-1 downto 0);
		cont:out bit_vector((w)*(d)-1 downto 0);
		clk,reset,enable,load: in bit);
end component;
component digitByDigit is
	port (a,b: in bit_vector (3 downto 0);
		p: out bit_vector (3 downto 0);
		p1:out bit_vector (2 downto 0));
End component;
component recoder is
	port (a: in bit_vector (3 downto 0); --input digit
		ge5_i: in bit;	-- to indicate wether ai-1 >= 5 or not
		as: out bit_vector (3 downto 0); --output digit (recoded digit)
		ge5i: out bit); -- to indicate wether ai >= 5 or not
End component;
component recoder2 is
	port (a1: in bit_vector (3 downto 0); --input digit (ones)
		a2: in bit_vector (2 downto 0); --input digit (tens)
		b1,b2: out bit_vector (4 downto 0)); --output digit (ones,tens)
End component;
component recoder3 is
	port (a: in bit_vector (4 downto 0); --input digit 
		t_in: in bit; --input transfer digit
		t_out: out bit; --output transfer digit
		b: out bit_vector (3 downto 0)); --output digit (ones,tens)
End component;
component ErleCont is
	generic (n: positive := 8);
	port (start,clk: in bit;
		enaA,enaB,ldB,rst,enaPP: out bit);
End component;
component dadder is -- Svoboda d-digit adder
	generic (d: positive := 6);
	port (i1,i2:in bit_vector(5*d-1 downto 0);
		o:out bit_vector(5*d+4 downto 0));
end component;
signal VDD: bit := '1';
signal GND: bit := '0';
signal Regin,Regout: bit_vector (1 downto 0);
signal rstA,enaA,enaB,ldB,cn2,rstPP,enaPP: bit;
signal ge,t: bit_vector (n-1 downto 0);
signal A_out: bit_vector (4*n-1 downto 0);
signal PP1,As1: bit_vector (4*n+3 downto 0); -- 1 additional digit
signal PP10: bit_vector (3*n+2 downto 0);
signal PP1S,PP10S,PPSum,PPComp,PPi_1,PPi:bit_vector (5*n+4 downto 0);
signal PPit:bit_vector (5*n+9 downto 0);
signal LSD,Bd,Bds: bit_vector(3 downto 0);
signal Z,ca: bit_vector (4 downto 0);
begin
	cont: ErleCont generic map(n) port map (strt,clk,enaA,enaB,ldB,rstPP,enaPP);
	RegA: reg generic map (4*n) port map (A,A_out,clk,GND,enaA); -- Register for Multiplicand
	RegB: RShreg generic map (n,4) port map (B,LSD,Bd,P(4*n-1 downto 0),clk,GND,enaB,ldB); -- Register for Multiplier
	
	s10: recoder port map (A_out (3 downto 0),GND,As1(3 downto 0),ge(0));
		
	RCD1:for k in 1 to n-1 generate -- recoding from BCD -> [-5,5] (2's comp)
		s1:recoder port map (A_out(4*k+3 downto 4*(k)),ge(k-1), As1(4*k+3 downto 4*(k)),ge(k));
	end generate;
	As1(4*n) <= ge(n-1);
	As1(4*n+3 downto 4*n+1) <= "000";
	
	rcdB: recoder port map (Bd,regout(0),Bds,regin(0)); -- recode multiplier digit Bd
	RegT: reg generic map (2) port map (Regin,Regout,clk,rstPP,enaB); -- to store ge of B digit and to store T of LSD digit recoder3
	
	PPG:for k in 1 to n+1 generate -- Generation of Partial Products
		s2:digitByDigit port map (As1(4*k-1 downto 4*(k-1)),Bds, PP1(4*k-1 downto 4*(k-1)),PP10(3*k-1 downto 3*(k-1)));
	end generate;
	
	RDC2:for k in 1 to n+1 generate -- recoding [-5,5] (2's Comp) -> Svoboda
		s3:recoder2 port map (PP1(4*k-1 downto 4*(k-1)),PP10(3*k-1 downto 3*(k-1)),PP1S(5*k-1 downto 5*(k-1)),PP10S(5*k-1 downto 5*(k-1)));
	end generate;
	
	------------------- Remove the overlapping ----------------------
	Overlap:dadder generic map (n) port map (PP1S(5*n+4 downto 5),PP10S(5*n-1 downto 0),PPSum);
	-- add the MSD of tens with Transfer Digit
	cn2<= (PPSum(5*n) and PPSum(5*n+4)) or (PP10S(5*n+1) and  (not PP10S(5*n+0)) and PPSum(5*n+4)) or  (PP10S(5*n+3) and PPSum(5*n+4))
		 or (PP10S(5*n+4) and PPSum(5*n+4)) or (PP10S(5*n+4) and PP10S(5*n+3) and PP10S(5*n+1) and PPSum(5*n)); -- tpi = PPSum(5*n)
	Overlap0: FA port map (PP10S(5*n+0),PPSum(5*n),cn2,Z(0),ca(0));
	Overlap1: FA port map (PP10S(5*n+1),PPSum(5*n),ca(0),Z(1),ca(1));
	Overlap2: FA port map (PP10S(5*n+2),PPSum(5*n+4),ca(1),Z(2),ca(2));
	Overlap3: FA port map (PP10S(5*n+3),PPSum(5*n+4),ca(2),Z(3),ca(3));
	Overlap4: FA port map (PP10S(5*n+4),PPSum(5*n+4),ca(3),Z(4),ca(4));
	-------------------------------------------------------------------
	PPComp <= Z & PPSum (5*n-1 downto 0); -- complete Partial product generated
	-- add the PP with accumilated PP
	Add:dadder generic map (n+1) port map (PPComp,PPi_1,PPit);
	PPi <= PPit (5*n+4 downto 0);
	PPreg: reg generic map (5*(n+1)) port map (PPi,PPi_1,clk,rstPP,enaPP);
	
	-- recode LSD and SHR to Reg B
	LSDRcd: recoder3 port map (PP1(4 downto 0),regout(1),regin(1),LSD);
	
	-- recode remaining digits
	s40:recoder3 port map (PPi_1(4 downto 0),regout(1),t(0),P(4*n+3 downto 4*n));
	RDC3:for k in 1 to n-1 generate -- recoding [-5,5] Svoboda -> BCD
		s4:recoder3 port map (PPi_1(5*k-1 downto 5*(k-1)),t(k-1),t(k),P(4*(k+n)+3 downto 4*(k+n)));
	end generate;
End stuct;