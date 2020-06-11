var
  NowTesting, HostName, Message, Suffix: string;
  Port: integer;
  DT: DateTime;
  IP: System.Net.IPAddress;
  EP: System.Net.IPEndPoint;
  NS: System.Net.Sockets.NetworkStream;
  TCPClient: System.Net.Sockets.TcpClient;
  UDPClient: System.Net.Sockets.UdpClient;
  Buffer: array of byte;
  
begin
  Write('Имя хоста: ');
  Readln(HostName);
  IP := System.Net.Dns.GetHostAddresses(HostName)[0];
  Write('Порт: ');
  Readln(Port);
  EP := new System.Net.IPEndPoint(IP, Port);
  Write('Протокол: ');
  Readln(NowTesting);
  if (NowTesting.ToUpper = 'TCP') then
  begin
    TCPClient.Connect(EP);
    NS := TCPClient.GetStream();
    Writeln('Подключился! Ожидаю ваших сообщений...');
    while true do
    begin
      if NS.CanWrite then
      begin
      Suffix := '';
      Readln(Message);
      Buffer := System.Text.Encoding.ASCII.GetBytes(Message);
      try
        NS.Write(Buffer, 0, Buffer.Length);
      except
       on ex: Exception do
        Suffix := ex.Message;
      end;
      if (Suffix = '') then Suffix := '(Ошибки не произошло!)';
      DT := DateTime.Now;
      Writeln('<', DT.Hour, ':', DT.Minute, ':', DT.Second, '> ', Message, ' ', Suffix);
    end;
    End;
  end;
  if (NowTesting.ToUpper = 'UDP') then
  BEGIN
    UDPClient.Connect(EP);
    Writeln('Подключился! Ожидаю ваших сообщений...');
    while true do
    begin
      Suffix := '';
      Readln(Message);
      Buffer := Encoding.ASCII.GetBytes(Message);
      try
        UDPClient.Send(Buffer, Buffer.Length);
      except
      on ex: Exception do
        Suffix := ex.Message;
      end;
      if (Suffix = '') then Suffix := 'Операция прошла успешно!';
      Writeln('<', DT.Hour, ':', DT.Minute, ':', DT.Second, '> ', Message, ' ', Suffix);
    end;
  End;
end.