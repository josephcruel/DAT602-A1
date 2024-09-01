using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace IslandGame
{
    public partial class Register : Form
    {
        public Register()
        {
            InitializeComponent();
        }

        private void btnBackButton_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void Register_Load(object sender, EventArgs e)
        {
            DataAccess dataAccess = new DataAccess();
            string result = dataAccess.RegisterConnection();
            MessageBox.Show(result);
        }

        private void btnRegister_Click(object sender, EventArgs e)
        {
            DataAccess dataAccess = new DataAccess();
            string result = dataAccess.RegisterSuccess();
            MessageBox.Show(result);

            MainScreen mainScreen = new MainScreen();
            this.Hide();
            mainScreen.Show();

        }
    }
}
