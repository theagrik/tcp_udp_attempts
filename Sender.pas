uses EasyTCP, EasyUDP;

var
  NowTesting, IP, Message, Suffix: string;
  Port: integer;
  DT: DateTime;

begin
  Write('IP-адрес: ');
  Readln(IP);
  Write('Порт: ');
  Readln(Port);
  Write('Протокол: ');
  Readln(NowTesting);
  if (NowTesting.ToUpper = 'TCP') then
  begin
    EasyTCP.Connect(IP, Port);
    Writeln('Подключился! Ожидаю ваших сообщений...');
    while true do
    begin
      Suffix := '';
      Readln(Message);
      try
        EasyTCP.WriteInto(EasyTCP.StrToByte(Message));
      except
        Suffix := '(Произошла ошибка!)';
      end;
      if (Suffix = '') then Suffix := '(Ошибки не произошло!)';
      Writeln('<', DT.Hour, ':', DT.Minute, ':', DT.Second, '> ', Message, ' ', Suffix);
    end;
  end;
  if (NowTesting.ToUpper = 'UDP') then
  BEGIN
    EasyUDP.Connect(IP, Port);
    Writeln('Подключился! Ожидаю ваших сообщений...');
    while true do
    begin
      Suffix := '';
      Readln(Message);
      try
        //EasyUDP.Send(EasyTCP.StrToByte(Message));
      except
      on ex: Exception do
        Suffix := ex.Message;
      end;
      if (Suffix = '') then Suffix := '(Ошибки не произошло!)';
      Writeln('<', DT.Hour, ':', DT.Minute, ':', DT.Second, '> ', Message, ' ', Suffix);
    end;
  End;
end.