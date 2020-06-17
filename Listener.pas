var
  NowTesting: string;
  Port: integer;
  DT: DateTime;
  TL: System.Net.Sockets.TcpListener;
  Buffer: array of byte;

begin
  Write('Порт: ');
  Readln(Port);
  Write('Протокол: ');
  Readln(NowTesting);
  if (NowTesting = 'TCP') then
  begin
    TL := System.Net.Sockets.TcpListener.Create(Port);
    TL.Start;
    while (not TL.Pending) do 
    begin
      writeln('Слушаю порт ', Port, '...');
      sleep(1000);
    end;
    var Client := TL.AcceptTcpClient;
    var NS := Client.GetStream;
    Writeln('Есть контакт! Включаю чат... ');
    while True do
    begin
      if NS.CanRead then
      begin
        var Message := new StringBuilder();
        var BytesRead := 0;
        while NS.DataAvailable do
        begin
          BytesRead := NS.Read(Buffer, 0, Buffer.Length);
          Message.AppendFormat(Encoding.ASCII.GetString(Buffer, 0, BytesRead), Encoding.ASCII.GetString(Buffer, 0, BytesRead));
        end;
        DT := DateTime.Now;
        Writeln('<', DT.Hour, ':', DT.Minute, ':', DT.Second, '> ', Message);
      end;
    end;
  end;
  if (NowTesting = 'UDP') then
  begin
    var Client := new System.Net.Sockets.UdpClient(Port);
    var EP := new System.Net.IPEndPoint(System.Net.IPAddress.Any, 0);
    while true do
    begin
      DT := DateTime.Now;
      Writeln('<', DT.Hour, ':', DT.Minute, ':', DT.Second, '> ',  Encoding.ASCII.GetString(Client.Receive(EP)));
    end;
  end;
end.