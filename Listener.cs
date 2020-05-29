using System;
using System.Net.Sockets;
using System.Text;
using System.Threading;

namespace Test
{
    class Program
    {
        static void Main(string[] args)
        {
            DateTime DT = DateTime.Now;
            Console.Write("Порт: ");
            int Port = Convert.ToInt32(Console.ReadLine());
            Console.Write("Протокол: ");
            string NowTesting = Console.ReadLine();
            if (NowTesting == "TCP")
            {
                TcpListener TL = TcpListener.Create(Port);
                TL.Start();
                while (!TL.Pending())
                {
                    Console.WriteLine($"Слушаю порт {Port}...");
                    Thread.Sleep(1000);
                }
                TcpClient Client = TL.AcceptTcpClient();
                NetworkStream NS = Client.GetStream();
                Console.WriteLine("Есть контакт! Включаю чат... ");
                while (true)
                {
                    if (NS.DataAvailable && NS.CanRead)
                    {
                        byte[] Buffer = new byte[1024];
                        StringBuilder Message = new StringBuilder();
                        int BytesRead = 0;

                        do
                        {
                            BytesRead = NS.Read(Buffer, 0, Buffer.Length);

                            Message.AppendFormat("{0}", Encoding.ASCII.GetString(Buffer, 0, BytesRead));
                        }
                        while (NS.DataAvailable);
                        Console.WriteLine($"<{DT.Hour}:{DT.Minute}:{DT.Second}>: {Message}");
                    }
                }
            }
            if (NowTesting == "UDP")
            {
                UdpClient Client = new UdpClient(Port);
                System.Net.IPEndPoint EP = new System.Net.IPEndPoint(System.Net.IPAddress.Any, 0);
                //Client.Connect(EP);
                Client.Receive(ref EP);
                while (true)
                {
                    Console.WriteLine($"<{DT.Hour}:{DT.Minute}:{DT.Second}>: {Encoding.ASCII.GetString(Client.Receive(ref EP))}");
                }
            }
        }
    }
}
