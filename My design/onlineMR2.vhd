architecture fnl421 of onlineMR is
-- needed component
component Mux2X1En is
	generic (d: positive := 10);
	port (en,sel: in bit;
		input0,input1: in bit_vector(5*d-1 downto 0);
		output: out bit_vector(5*d-1 downto 0));
end component;

component negate is
	generic (d: positive := 3);
	port ( X: in bit_vector(5*d-1 downto 0); -- input digits
		sgn: in bit;
		Z: out bit_vector(5*d-1 downto 0)); -- output digit
end component;

component SbvdwordX2 is
	generic (d: positive := 3);
	port (i:in bit_vector(5*d-1 downto 0);
		o:out bit_vector(5*d+4 downto 0));
end component;

component Bufr is
	generic (d: positive := 10);
	port (en: in bit;
		input:	in  bit_vector(5*d-1 downto 0);
		output:out bit_vector(5*d-1 downto 0));
end component;

component dreg is
	generic (d: positive :=10);
	port (i:in bit_vector(5*d-1 downto 0);
		o:out bit_vector(5*d-1 downto 0);
		clk,reset,enable: in bit);
end component;

component dadder is
	generic (d: positive := 3);
	port (i1,i2:in bit_vector(5*d-1 downto 0);
		o:out bit_vector(5*d+4 downto 0));
end component;

component control421 is
	port (xi,yi: in bit_vector (4 downto 0);
			signX,signY: out bit; --sign of the new numbers and clock signal
			muxy_Sel,muxx_Sel: out bit; -- select signals for muxs
			muxy_En,muxx_En,Enx,Eny: out bit); -- Enable signals for muxs
end component;

component RAReg is
	generic (d: positive :=4);
	port (i:in bit_vector(4 downto 0);
		o:out bit_vector(5*(d)-1 downto 0);
		clk,reset: in bit);
end component;

component SelD is
	port (	wi: in bit_vector (4 downto 0);
		wi_1: in bit_vector (4 downto 0);
		di: out bit_vector (4 downto 0));
End component;

-- intermediate signals
signal y_temp,x_tmp,y_tmp,xb01_t,yb01_t: bit_vector (5*dd-1 downto 0);
signal x4,y4,x2,y2,my24,mx24,xb01,yb01, mx15_n,mx12_n,ytmp,xtmp,yntmp,xntmp: bit_vector (5*dd+4 downto 0);
signal Wi_1t,Wi,sum,add_x,add_y,sumx_n,sumy_n,x4_t,y4_t: bit_vector (5*(dd+2)-1 downto 0);
signal sum_t,Wi_1: bit_vector (5*(dd+3)-1 downto 0);
signal w:bit_vector (5*(dd+4)-1 downto 0);
signal yd,xd,di: bit_vector (4 downto 0);
signal di_n: bit_vector (9 downto 0);
signal wi_t: bit_vector (14 downto 0);
signal sgnx,sgny,mxxs,mxys,mxxe,mxye,en1x,en1y: bit;
signal GND: bit := '0';
signal VDD: bit := '1';

begin
	cont: control421 port map (xd,yd,sgnx,sgny,mxys,mxxs,mxye,mxxe,en1y,en1x);
	YDig: dreg generic map (1) port map (y,yd,clock,rst,VDD);
	XDig: dreg generic map (1) port map (x,xd,clock,rst,VDD);
	YY: RAReg generic map (dd) port map (yd,y_temp,clock,rst); -- connect the reset signal to the global reset signal of the multiplier
	XX: RAReg generic map (dd) port map (X,X_tmp,clock,rst); -- connect the reset signal to the global reset signal of the multiplier
	
	y_tmp <= y_temp (5*dd-6 downto 0)&"00000";
	xx2: SbvdwordX2 generic map(dd)	port map (x_tmp,x2);
	yx2: SbvdwordX2 generic map(dd)	port map (y_tmp,y2);
	xx4: SbvdwordX2 generic map(dd+1)	port map (x2,x4_t);
	yx4: SbvdwordX2 generic map(dd+1)	port map (y2,y4_t);
	x4 <= x4_t(5*dd+4 downto 0);
	y4 <= y4_t(5*dd+4 downto 0);
	-----------------------
	--ytmp <= "00000"&y_tmp;
	--xtmp <= "00000"&x_tmp;
	--yntmp <= "00000"&y_n;
	--xntmp <= "00000"&x_n;
	-----------------------
	muxy: Mux2X1En generic map (dd+1)	port map (mxye,mxys,y2,y4,my24);
	muxx: Mux2X1En generic map (dd+1)	port map (mxxe,mxxs,x2,x4,mx24);
	bufx: bufr generic map (dd)	port map(en1y,x_tmp,xb01_t);
	bufy: bufr generic map (dd)	port map(en1x,y_tmp,yb01_t);
	xb01 <= "00000"&xb01_t;
	yb01 <= "00000"&yb01_t;
	
	negy: negate generic map (dd+2) port map (add_y,sgnx,sumy_n);
	negx: negate generic map (dd+2) port map (add_x,sgny,sumx_n);
	--negy2: negate generic map (dd+1) port map (my12,sgnx,my12_n);
	--negx2: negate generic map (dd+1) port map (mx12,sgny,mx12_n);
	addx: dadder generic map(dd+1)	port map (xb01,mx24,add_x);
	addy: dadder generic map(dd+1)	port map (yb01,my24,add_y);
	addsum: dadder generic map(dd+2)	port map (sumx_n,sumy_n,sum_t);
	sum <= sum_t(5*dd+9 downto 0);
	addfn: dadder generic map(dd+3)	port map (sum_t,Wi_1,W);
	selOut: SelD port map (W(5*dd+14 downto 5*dd+10),W(5*dd+9 downto 5*dd+5),di);
	Z <= di;
	negd: negate generic map (1) port map (di,VDD,di_n(9 downto 5));
	di_n(4 downto 0) <= "00000";
	addW: dadder generic map(2)	port map (di_n,W(5*dd+14 downto 5*dd+5),Wi_t);
	Wi <= wi_t(4 downto 0) & W(5*(dd+1)-1 downto 0);
	regW: dreg generic map (dd+2) port map (Wi,Wi_1t,clock,rst,VDD);
	Wi_1 <= Wi_1t&"00000";
	Zlow <= Wi;

end fnl421;

architecture fnl of onlineMR is
-- needed component
component Mux2X1En is
	generic (d: positive := 10);
	port (en,sel: in bit;
		input0,input1: in bit_vector(5*d-1 downto 0);
		output: out bit_vector(5*d-1 downto 0));
end component;

component negate is
	generic (d: positive := 3);
	port ( X: in bit_vector(5*d-1 downto 0); -- input digits
		sgn: in bit;
		Z: out bit_vector(5*d-1 downto 0)); -- output digit
end component;

component SbvdwordX2 is
	generic (d: positive := 3);
	port (i:in bit_vector(5*d-1 downto 0);
		o:out bit_vector(5*d+4 downto 0));
end component;

component SbvdwordX5 is
	generic (d: positive := 3);
	port (i:in bit_vector(5*d-1 downto 0);
		o:out bit_vector(5*d+4 downto 0));
end component;

component dreg is
	generic (d: positive :=10);
	port (i:in bit_vector(5*d-1 downto 0);
		o:out bit_vector(5*d-1 downto 0);
		clk,reset,enable: in bit);
end component;

component dadder is
	generic (d: positive := 3);
	port (i1,i2:in bit_vector(5*d-1 downto 0);
		o:out bit_vector(5*d+4 downto 0));
end component;

component control521 is
	port (xi,yi: in bit_vector (4 downto 0);
			signX,signY: out bit; --sign of the new numbers
			muxy5_Sel,muxx5_Sel,muxy2_Sel,muxx2_Sel: out bit; -- select signals for muxs
			muxy5_En,muxx5_En,muxy2_En,muxx2_En: out bit); -- Enable signals for muxs
end component;

component RAReg is
	generic (d: positive :=4);
	port (i:in bit_vector(4 downto 0);
		o:out bit_vector(5*(d)-1 downto 0);
		clk,reset: in bit);
end component;

component Shreg is
	generic (d: positive :=10);
	port (i:in bit_vector(4 downto 0);
		o:out bit_vector(5*(d)-1 downto 0);
		clk,reset,enable: in bit);
end component;

component SelD is
	port (	wi: in bit_vector (4 downto 0);
		wi_1: in bit_vector (4 downto 0);
		di: out bit_vector (4 downto 0));
End component;

-- intermediate signals
signal y_temp,x_tmp,y_tmp,x_n,y_n: bit_vector (5*dd-1 downto 0);
signal x5,y5,x2,y2,my15,my12,mx15,mx12,my15_n,my12_n,mx15_n,mx12_n,ytmp,xtmp,yntmp,xntmp: bit_vector (5*dd+4 downto 0);
signal Wi_1t,Wi,sum,add_15,add_12,add_X,add_Y,add_Xn,add_Yn: bit_vector (5*(dd+2)-1 downto 0);
signal sum_t,Wi_1: bit_vector (5*(dd+3)-1 downto 0);
signal w:bit_vector (5*(dd+4)-1 downto 0);
signal yd,xd,di: bit_vector (4 downto 0);
signal di_n: bit_vector (9 downto 0);
signal wi_t: bit_vector (14 downto 0);
signal sgnx,sgny,mxx2s,mxx5s,mxy2s,mxy5s,mxx2e,mxx5e,mxy2e,mxy5e: bit;
signal GND: bit := '0';
signal VDD: bit := '1';

begin
	cont: control521 port map (xd,yd,sgnx,sgny,mxy5s,mxx5s,mxy2s,mxx2s,mxy5e,mxx5e,mxy2e,mxx2e);
	YDig: dreg generic map (1) port map (y,yd,clock,rst,VDD);
	XDig: dreg generic map (1) port map (x,xd,clock,rst,VDD);
	YY: RAReg generic map (dd) port map (yd,y_temp,clock,rst); -- connect the reset signal to the globale reset signal of the multiplier
	XX: RAReg generic map (dd) port map (X,X_tmp,clock,rst); -- connect the reset signal to the globale reset signal of the multiplier

	--YY: Shreg generic map (dd) port map (yd,y_temp,clock,GND,VDD); -- connect the reset signal to the globale reset signal of the multiplier
	--XX: Shreg generic map (dd) port map (X,X_tmp,clock,GND,VDD); -- connect the reset signal to the globale reset signal of the multiplier
	
	y_tmp <= y_temp (5*dd-6 downto 0)&"00000";
	xx5: SbvdwordX5 generic map(dd)	port map (x_tmp,x5);
	yx5: SbvdwordX5 generic map(dd)	port map (y_tmp,y5);
	xx2: SbvdwordX2 generic map(dd)	port map (x_tmp,x2);
	yx2: SbvdwordX2 generic map(dd)	port map (y_tmp,y2);
	negx: negate	generic map (dd) port map (x_tmp,VDD,x_n);
	negy: negate	generic map (dd) port map (y_tmp,VDD,y_n);
	ytmp <= "00000"&y_tmp;
	xtmp <= "00000"&x_tmp;
	yntmp <= "00000"&y_n;
	xntmp <= "00000"&x_n;
	muxy5: Mux2X1En generic map (dd+1)	port map (mxy5e,mxy5s,ytmp,y5,my15);
	muxx5: Mux2X1En generic map (dd+1)	port map (mxx5e,mxx5s,xtmp,x5,mx15);
	muxy2: Mux2X1En generic map (dd+1)	port map (mxy2e,mxy2s,yntmp,y2,my12);
	muxx2: Mux2X1En generic map (dd+1)	port map (mxx2e,mxx2s,xntmp,x2,mx12);
	--negy5: negate generic map (dd+1) port map (my15,sgnx,my15_n);
	--negx5: negate generic map (dd+1) port map (mx15,sgny,mx15_n);
	--negy2: negate generic map (dd+1) port map (my12,sgnx,my12_n);
	--negx2: negate generic map (dd+1) port map (mx12,sgny,mx12_n);
	--add5: dadder generic map(dd+1)	port map (my15_n,mx15_n,add_15);
	--add2: dadder generic map(dd+1)	port map (my12_n,mx12_n,add_12);
	
	addX: dadder generic map(dd+1)	port map (mx12,mx15,add_X);
	addY: dadder generic map(dd+1)	port map (my12,my15,add_Y);
	negAddX: negate generic map (dd+2) port map (add_X,sgny,add_Xn);
	negAddY: negate generic map (dd+2) port map (add_Y,sgnx,add_Yn);
	addsum: dadder generic map(dd+2)	port map (add_Xn,add_Yn,sum_t);
	
	--addsum: dadder generic map(dd+2)	port map (add_12,add_15,sum_t);
	sum <= sum_t(5*dd+9 downto 0);
	addfn: dadder generic map(dd+3)	port map (sum_t,Wi_1,W);
	selOut: SelD port map (W(5*dd+14 downto 5*dd+10),W(5*dd+9 downto 5*dd+5),di);
	Z <= di;
	negd: negate generic map (1) port map (di,VDD,di_n(9 downto 5));
	di_n(4 downto 0) <= "00000";
	addW: dadder generic map(2)	port map (di_n,W(5*dd+14 downto 5*dd+5),Wi_t);
	Wi <= wi_t(4 downto 0) & W(5*(dd+1)-1 downto 0);
	regW: dreg generic map (dd+2) port map (Wi,Wi_1t,clock,rst,VDD);
	Wi_1 <= Wi_1t&"00000";
	Zlow <= Wi;
end fnl;