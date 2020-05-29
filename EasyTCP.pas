unit EasyTCP;
interface
uses System.Net, System.Text, System.Threading;

Var
Client: System.Net.Sockets.TcpClient;
IP: System.Net.IPAddress;
EP: IPEndPoint;
NS: System.Net.Sockets.NetworkStream;
TL: System.Net.Sockets.TcpListener;
B: array of byte;

//****************
//Объявленные функции и процедуры
//****************

//Процедуры и функции клиента

///Инициализация подключения и сетевого взаимодействия.
///После выполнения создает переменную NS, которую можно присвоить любой другой переменной.
Procedure Connect(HostName: string; Port: integer);
///Закрытие подключения
Procedure Close;

//Процедуры и функции слушателя

///Инициализация слушателя TCP, вызывается лишь один раз на протяжении программы.
///Важно: не запускает прослушку порта!
Procedure InitializeListener(Port: integer);

///Запуск прослушки порта.
Procedure StartListener;

///Остановка прослушки порта.
Procedure StopListener;

///Проверка наличия запросов на подключение. 
Function Pending: boolean;

///Принятие запроса на подключение, инициализация подключения и сетевого взаимодействия.
///После выполнения создает переменную NS, которую можно присвоить любой другой переменной.
Procedure AcceptConnectByListener;

//Процедуры и функции стрима

///Процедура записи данных в поток сообщений.
Procedure WriteInto(Buffer: array of byte);

///Функция чтения данных из потока сообщений.
Function ReadFrom: array of byte;

///Функция, возвращающая возможность доступа к данным.
Function Available: boolean;

//Иные процедуры и функции

///Функция преобразования строки в массив байт.
Function StrToByte(Data: string): array of byte;
///Функция преобразования массива байт в строку.
Function ByteToStr(Data: array of byte): string;



implementation

//Процедуры и функции клиента

Procedure Close;
BEGIN
  Client.Close;
End;

Procedure Connect(HostName: string; Port: integer);
BEGIN
  IP := Dns.GetHostAddresses(HostName)[0];
  EP := new IpEndPoint(IP, Port);
  Client.Connect(EP);
  NS := Client.GetStream;
End;

//Процедуры и функции слушателя

Procedure InitializeListener(Port: integer);
BEGIN
  TL := new System.Net.Sockets.TcpListener(Port);
End;

Procedure StartListener;
BEGIN
  TL.Start;
End;

Procedure StopListener;
BEGIN
  TL.Stop;
End;

Function Pending: boolean;
BEGIN
  Result := TL.Pending;
End;

Procedure AcceptConnectByListener;
BEGIN
  Client := TL.AcceptTcpClient;
  NS := Client.GetStream;
End;

//Процедуры и функции стрима

Procedure WriteInto(Buffer: array of byte);
BEGIN
  B := B + Buffer;
  NS.Write(B, NS.Position, B.Length);
End;

///Функция чтения данных из потока сообщений.
Function ReadFrom: array of byte;
BEGIN
  NS.Read(B, NS.Position, NS.Length);
  Result := B;
End;

Function Available: boolean;
BEGIN
  Result := NS.DataAvailable;
End;

//Иные процедуры и функции

Function StrToByte(Data: string): array of byte;
BEGIN
  Result := Encoding.ASCII.GetBytes(Data);
End;

Function ByteToStr(Data: array of byte): string;
BEGIN
  Result := Encoding.ASCII.GetString(Data);
End;

end.