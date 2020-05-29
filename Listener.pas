uses EasyTCP, EasyUDP;

var
  NowTesting, IP, Message, Suffix: string;
  Port: integer;
  DT: DateTime;

begin
  Write('Порт: ');
  Readln(Port);
  Write('Протокол: ');
  Readln(NowTesting);
  if (NowTesting = 'TCP') then
  begin
    EasyTCP.InitializeListener(Port);
    EasyTCP.StartListener;
    while (not EasyTCP.Pending) do 
    begin
      writeln('Слушаю порт ', Port, '...');
      sleep(1000);
    end;
    EasyTCP.AcceptConnectByListener;
    Writeln('Есть контакт! Включаю чат... ');
    while True do
    begin
      if EasyTCP.Available then
        Writeln('<', DT.Hour, ':', DT.Minute, ':', DT.Second, '> ', EasyTCP.ByteToStr(EasyTCP.ReadFrom));
    end;
  end;
  if (NowTesting = 'UDP') then
  BEGIN
    EasyUDP.Connect(System.Net.IPAddress.Any, Port);
    Writeln('Ожидаю входящих сообщений на порт ', Port);
    EasyUDP.Receive;
  End;
end.