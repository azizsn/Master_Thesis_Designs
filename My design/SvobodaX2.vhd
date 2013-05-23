-- this component accepts a decimal digit coded in Svoboda encoding and multiplies it by 2

entity svbdX2 is
	port ( X: in bit_vector(4 downto 0); -- input digits
		tpi,tni: in bit;
		Z: out bit_vector(4 downto 0); -- output digit
		tpo,tno: out bit);-- tpo = transfer positive bit (output), tno = transfer negative bit(output)
end svbdX2;

architecture df of svbdX2 is

component FA
	port ( a,b,c: in bit;
		sum,carry: out bit);
end component;
signal Y,carry: bit_vector (4 downto 0);
signal cn: bit;
begin
	tpo <= Not X(4) and X(3);
	tno <= Not X(3) and X(4);
	Y(0) <= X(3);
	Y(1) <= X(0);
	Y(2) <= X(1);
	Y(3) <= X(2);
	Y(4) <= X(3);
	cn <= (tpi and tni) or (Y(1) and  (not Y(0)) and tni) or  (Y(3) and tni)or (Y(4) and tni)
		or (Y(4) and Y(3) and Y(1) and tpi);
	
	reduce0: FA port map (Y(0),tpi,cn,Z(0),carry(0));
	reduce1: FA port map (Y(1),tpi,carry(0),Z(1),carry(1));
	reduce2: FA port map (Y(2),tni,carry(1),Z(2),carry(2));
	reduce3: FA port map (Y(3),tni,carry(2),Z(3),carry(3));
	reduce4: FA port map (Y(4),tni,carry(3),Z(4),carry(4));

end df;