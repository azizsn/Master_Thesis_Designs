-- recode digit from [0,9] -> [-5,5] (2'complement representation)
Entity recoder is
	port (a: in bit_vector (3 downto 0); --input digit
			ge5_i: in bit;	-- to indicate wether ai-1 >= 5 or not
			as: out bit_vector (3 downto 0); --output digit (recoded digit)
			ge5i: out bit); -- to indicate wether ai >= 5 or not
End entity;

architecture arc of recoder is
	signal ai,ac,aic: bit_vector (3 downto 0);
	signal gt: bit;
	signal sel: bit_vector (1 downto 0);
	
	component mux4X1 is
	generic (n: positive :=8);
	port ( I0,I1,I2,I3: in bit_vector (n-1 downto 0);
			s: in bit_vector(1 downto 0);
			o: out bit_vector (n-1 downto 0));
	end component ;
begin
	ai(3) <= '0';
	ai(2) <= not (not a(2) and not(a(1) or a(0)));
	ai(1) <= a(1) xor a(0);
	ai(0) <= not a(0);
	
	ac(3) <= '1';
	ac(2) <= not (not a(2) or (a(1) and a(0)));
	ac(1) <= not(a(1) xor a(0));
	ac(0) <= a(0);
	
	aic(3) <= '1';
	aic(2) <= not (a(3) or a(1));
	aic(1) <= a(1);
	aic(0) <= not a(0);
	
	gt <= not (not a(3) and not (a(2) and (a(1) or a(0))));
	ge5i <= gt ;
	sel <= gt&ge5_i;
	
	mux: mux4X1 generic map (4) port map (a,ai,ac,aic,sel,as);
end arc;