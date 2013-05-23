-- recode 2 digit from [-5,5] (2'complement representation) -> [-5,5] Svoboda
Entity recoder2 is
	port (a1: in bit_vector (3 downto 0); --input digit (ones)
		a2: in bit_vector (2 downto 0); --input digit (tens)
		b1,b2: out bit_vector (4 downto 0)); --output digit (ones,tens)
End entity;

Architecture behave of recoder2 is

begin
	P1: Process (a1,a2)
	begin
		case a1 is
			When "0000" => b1 <= "00000";
			When "0001" => b1 <= "00011";
			When "0010" => b1 <= "00110";
			When "0011" => b1 <= "01001";
			When "0100" => b1 <= "01100";
			When "0101" => b1 <= "01111";
			When "1000" => b1 <= "00000";
			When "1001" => b1 <= "11100";
			When "1010" => b1 <= "11001";
			When "1011" => b1 <= "10110";
			When "1100" => b1 <= "10011";
			When "1101" => b1 <= "10000";
			When others => b1 <= "00000";
		end case;
			
		case a2 is
			When "000" => b2 <= "00000";
			When "001" => b2 <= "00011";
			When "010" => b2 <= "00110";
			When "100" => b2 <= "00000";
			When "101" => b2 <= "11100";
			When "110" => b2 <= "11001";
			When others => b2 <= "00000";
		end case;
	end process;
End behave;