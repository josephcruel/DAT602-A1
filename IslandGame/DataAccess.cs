using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using MySql.Data.MySqlClient;
using System.Numerics;

namespace IslandGame
{
    class DataAccess
    {
        private static string connectionString
        {
            get { return "Server=localhost;Port=3306;Database=islandgamedb;Uid=Admin;password=root1234;"; }

        }

        private static MySqlConnection _mySqlConnection = null;
        public static MySqlConnection mySqlConnection
        {
            get
            {
                if (_mySqlConnection == null)
                {
                    _mySqlConnection = new MySqlConnection(connectionString);
                }

                return _mySqlConnection;

            }
        }

        public string RegisterConnection()
        {
            try
            {
                DataAccess.mySqlConnection.Open();
                return "Register Database connection is successful!!";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            finally
            {
                DataAccess.mySqlConnection.Close();
            }
        }

        public string LoginConnection()
        {
            try
            {
                DataAccess.mySqlConnection.Open();
                return "Login Database connection is successful!!";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            finally
            {
                DataAccess.mySqlConnection.Close();
            }
        }

        public string LoginSuccess()
        {
            try
            {
                DataAccess.mySqlConnection.Open();
                return "You are now logged in!";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            finally
            {
                DataAccess.mySqlConnection.Close();
            }
        }

        public string RegisterSuccess()
        {
            try
            {
                DataAccess.mySqlConnection.Open();
                return "You are now registered!";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            finally
            {
                DataAccess.mySqlConnection.Close();
            }
        }

        public string AdminConsole()
        {
            try
            {
                DataAccess.mySqlConnection.Open();
                return "Connected to the Admin Console";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            finally
            {
                DataAccess.mySqlConnection.Close();
            }
        }

        public string GameLobby()
        {
            try
            {
                DataAccess.mySqlConnection.Open();
                return "Returing to lobby";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            finally
            {
                DataAccess.mySqlConnection.Close();
            }
        }
        public string AddUserName(string pUserName)
        {

            List<MySqlParameter> parameters = new List<MySqlParameter>();
            var aP = new MySqlParameter("@pUserName", MySqlDbType.VarChar, 50);
            aP.Value = pUserName;
            parameters.Add(aP);


            var dataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "call AddUserName(@pUserName)", parameters.ToArray());

            // expecting one table with one row
            return (dataSet.Tables[0].Rows[0])["MESSAGE"].ToString();
        }

       
    }
}
