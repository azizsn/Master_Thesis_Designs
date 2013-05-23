-- recode a digit from [-5,5] Svoboda -> BCD
Entity recoder3 is
	port (a: in bit_vector (4 downto 0); --input digit 
		t_in: in bit; --input transfer digit
		t_out: out bit; --output transfer digit
		b: out bit_vector (3 downto 0)); --output digit (ones,tens)
End entity;

Architecture behave of recoder3 is

begin
	P1: Process (a,t_in)
		variable sign: bit;
	begin
		sign := a(0) xor a(1) xor a(2) xor a(3) xor a(4);
		if (t_in = '0') then
			t_out <= '0';
			case a is
				When "00000" => b <= "0000"; -- +0
				When "00011" => b <= "0001"; -- +1
				When "00110" => b <= "0010"; -- +2
				When "01001" => b <= "0011"; -- +3
				When "01100" => b <= "0100"; -- +4
				When "01111" => b <= "0101"; -- +5
				When "10010" => b <= "0110"; -- +6
				When "11111" => b <= "0000"; -- -0
				When "11100" => b <= "1001"; -- -1
				When "11001" => b <= "1000"; -- -2
				When "10110" => b <= "0111"; -- -3
				When "10011" => b <= "0110"; -- -4
				When "10000" => b <= "0101"; -- -5
				When "01101" => b <= "0100"; -- -6
				When others => b <= "0000";
			end case;
		else 
			case a is
				When "00000" => b <= "1001"; t_out <= '1'; -- +0
				When "00011" => b <= "0000"; t_out <= '0';-- +1
				When "00110" => b <= "0001"; t_out <= '0';-- +2
				When "01001" => b <= "0010"; t_out <= '0';-- +3
				When "01100" => b <= "0011"; t_out <= '0';-- +4
				When "01111" => b <= "0100"; t_out <= '0';-- +5
				When "10010" => b <= "0101"; t_out <= '0';-- +6
				When "11111" => b <= "1001"; t_out <= '1';-- -0
				When "11100" => b <= "1000"; t_out <= '1';-- -1
				When "11001" => b <= "0111"; t_out <= '1';-- -2
				When "10110" => b <= "0110"; t_out <= '1';-- -3
				When "10011" => b <= "0101"; t_out <= '1';-- -4
				When "10000" => b <= "0100"; t_out <= '1';-- -5
				When "01101" => b <= "0011"; t_out <= '1';-- -6
				When others => b <= "0000"; t_out <= '0';
			end case;
		end if;
	end process;
End behave;
