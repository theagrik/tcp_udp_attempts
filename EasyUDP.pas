unit EasyUDP;
interface
uses System.Net, System.Text, System.Threading, System.Windows;

Var
Client: System.Net.Sockets.UdpClient;
IP: System.Net.IPAddress;
EP: IPEndPoint;

///Функция отправки датаграммы. Возвращает количество отправленных байт.
Function Send(Datagram: array of byte): integer;
///Инициализация подключения
Procedure Connect(HostName: string; Port: integer);
///Инициализация подключения
Procedure Connect(IP: IPAddress; Port: integer);
///Закрытие подключения
Procedure Close;
///Функция, возвращающая полученные из заданного в Connect EndPoint данные. 
///Важно: останавливает ход программы до получения.
Function Receive: array of byte;

///Функция, возвращающая полученные из заданного EndPoint данные. 
///Важно: останавливает ход программы до получения.
Function Receive(Point: IPEndPoint): array of byte;

implementation

Procedure Close;
BEGIN
  Client.Close;
End;

Function Send(Datagram: array of byte): integer;
BEGIN
  Result := Client.Send(Datagram, Datagram.Length);
End;

Procedure Connect(HostName: string; Port: integer);
BEGIN
  IP := Dns.GetHostAddresses(HostName)[0];
  EP := new IpEndPoint(IP, Port);
  Client.Connect(EP);
End;

Procedure Connect(IP: IPAddress; Port: integer);
BEGIN
  EP := new IpEndPoint(IP, Port);
  Client.Connect(EP);
End;

Function Receive: array of byte;
BEGIN
  Result := Client.Receive(EP);
End;

Function Receive(Point: IPEndPoint): array of byte;
BEGIN
  Result := Client.Receive(Point);
End;
end.