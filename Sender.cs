using System;
using System.Net;
using System.Net.Sockets;

namespace Sender
{
    class Program
    {
        static void Main(string[] args)
        {
            DateTime DT = DateTime.Now;
            Console.Write("Имя хоста: ");
            string HostName = Console.ReadLine();
            System.Net.IPAddress IP = System.Net.Dns.GetHostAddresses(HostName)[0];
            Console.Write("Порт: ");
            int Port = Convert.ToInt32(Console.ReadLine());
            IPEndPoint EP = new IPEndPoint(IP, Port);
            Console.Write("Протокол: ");
            string NowTesting = Console.ReadLine();
            string Message;
            string Suffix;
            if (NowTesting == "TCP")
            {
                TcpClient Client = new TcpClient();
                Client.Connect(EP);
                NetworkStream NS = Client.GetStream();
                Console.WriteLine("Подключился! Ожидаю ваших сообщений...");
                while (true)
                {
                    if (NS.CanWrite)
                    {
                        Message = Console.ReadLine();
                        byte[] Buffer = System.Text.Encoding.ASCII.GetBytes(Message);
                        NS.Write(Buffer, 0, Buffer.Length);
                        Console.WriteLine($"<{DT.Hour}:{DT.Minute}:{DT.Second}>: {Message}");
                    }

                }
            }
            if (NowTesting == "UDP")
            {
                UdpClient Client = new UdpClient();
                Client.Connect(EP);
                Console.WriteLine("Подключился! Ожидаю ваших сообщений...");
                while (true) 
                {
                    Suffix = "";
                    Message = Console.ReadLine();
                    Byte[] Buffer = System.Text.Encoding.ASCII.GetBytes(Message);
                    try
                    {
                        Client.Send(Buffer, Buffer.Length);
                    }
                    catch (Exception e)
                    {
                        Suffix = e.ToString();
                    }
                    if (Suffix == "")
                    {
                        Suffix = "Операция прошла успешно!";
                    }
                    Console.WriteLine($"<{DT.Hour}:{DT.Minute}:{DT.Second}>: {Message} ({Suffix})");
                }
                
            }
        }
    }
}
