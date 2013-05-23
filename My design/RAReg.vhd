-- right-append register: appends the inputs to the right from the most significant position
Entity RAReg is
	generic (d: positive :=4);
	port (i:in bit_vector(4 downto 0);
		o:out bit_vector(5*(d)-1 downto 0);
		clk,reset: in bit);
end RAReg;

Architecture behave of RAReg is
begin
	process (clk,reset)
		variable tmp: bit_vector(5*d-1 downto 0);
		variable count: integer := d;
	begin
		if (reset = '1') then
			tmp := (others => '0');
			count:= d;
		elsif (clk = '1' and clk'event ) then --falling edge 
			if ( count > 0) then
				tmp(5*count-1 downto 5*(count-1)) := i;
				count := count -1;
			end if;
		end if;
		o <= tmp;
	end process;
end behave;


Architecture df of RAReg is

component dreg is
	generic (d: positive :=10);
	port (i:in bit_vector(5*d-1 downto 0);
		o:out bit_vector(5*d-1 downto 0);
		clk,reset,enable: in bit);
end component;

signal EnableD: bit_vector (d-1 downto 0);
begin
process (clk,reset)
	variable tmp: bit_vector(d-1 downto 0) := (1=>'1', others =>'0');
	begin
		if (reset = '1') then
			tmp := (others => '0');
			tmp(d-1) := '1';
		elsif (clk = '1' and clk'event ) then --rising edge
			tmp := '0' & (tmp (d-1 downto 1));
		end if;
		EnableD <= tmp;
end process;

RG: for c in d-1 downto 0 generate
		Digit :dreg generic map (1) port map (i,o(5*c+4 downto 5*c),clk,reset,EnableD(c));
	end generate;	
end df;