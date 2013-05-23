-- this component accepts a decimal digit coded in Svoboda encoding and multiplies it by 2

entity svbdX5 is
	port ( X,tf: in bit_vector(4 downto 0); -- input digit and transfered digit
		sgnb: in bit;-- sign of the previous digit (0 positive, 1 negative)
		sgnf: out bit; -- sign bit to the next digit
		Z,tb: out bit_vector(4 downto 0)); -- ouput digit, and the transfer-back digit 
		
end svbdX5;

architecture mixed of svbdX5 is 
signal y,tmpZ,carry1,carry2: bit_vector (4 downto 0);
signal cn1,cn2,tp,tn: bit;
--signal q1,q2,r1,r2,a1,a2: bit;
component FA
	port ( a,b,c: in bit;
		sum,carry: out bit);
end component;
begin
	process (X,tf,sgnb)
	variable tmpt: bit_vector (4 downto 0);
	begin
		tp <= '0';
		tn <= '0';
		if ((X(0) xor X(4)) = '1') then
			tmpt := (4 => X(4), others => X(0));
			if ((sgnb xor X(4)) = '0') then
				tmpt := not tmpt;
				tp <= not X(4);
				tn <= X(4);
			end if;
		else
			tmpt := "00000";			
		end if;
		tb <= tmpt;
	end process;
	
	sgnf <= X(4);
	tmpz(4) <= X(4);
	tmpz(3) <= X(4);
	tmpz(2) <= (X(3) and X(2)) or (X(4) and (X(1) xor X(0)));
	tmpz(1) <= (not X(4) and not X(1) and X(0)) or (not X(4) and X(2)) or (X(2) and X(3));
	tmpz(0) <= (not X(4) and not X(1) and X(0)) or (not X(4) and X(1) and not X(0)) or (X(4) and not X(3) and not X(2)) or (X(4) and X(3) and X(2));
	
--	q1 <= (not tmpz(0)) and tmpz(1) and (not tmpz(2));
--	r1 <= (not tmpz(0)) or tmpz(1) or (not tmpz(2));
--	q2 <= (not tf(0)) and tf(1) and (not tf(2));
--	r2 <= (not tf(0)) or tf(1) or (not tf(2));
--	a1 <= (tmpz(0) or q1) and r1;
--	a2 <= (tf(0) or q2) and r2;
	
	cn1<= (tmpz(1) and tf(2) and tf(1) and tf(0)) or (tmpz(2) and tf(3) and tf(2)) 
		or (tmpz(3) and tf(3)) or (tmpz(3) and tmpz(1) and tf(1)) or (tmpz(3) and tmpz(2) and tf(2));
	cn2<= (tp and tn) or (y(1) and  (not y(0)) and tn) or  (y(3) and tn)
		 or (y(4) and tn) or (y(4) and y(3) and y(1) and tp);
	
	
	--Stage10: FA port map (a1,a2,cn1,y(0),carry1(0));
	Stage10: FA port map (tmpz(0),tf(0),cn1,y(0),carry1(0));
	g1:for i in 1 to 4 generate
		stage1:FA port map (tmpz(i),tf(i),carry1(i-1),y(i),carry1(i));
	end generate;	
	
	Stage20: FA port map (y(0),tp,cn2,Z(0),carry2(0));
	Stage21: FA port map (y(1),tp,carry2(0),Z(1),carry2(1));
	Stage22: FA port map (y(2),tn,carry2(1),Z(2),carry2(2));
	Stage23: FA port map (y(3),tn,carry2(2),Z(3),carry2(3));
	Stage24: FA port map (y(4),tn,carry2(3),Z(4),carry2(4));
	
end mixed;
