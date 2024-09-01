﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace IslandGame
{
    public partial class Login : Form
    {
        public Login()
        {
            InitializeComponent();
        }

        private void btnBackButton_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void btnLogIn_Click(object sender, EventArgs e)
        {
            DataAccess dataAccess = new DataAccess();
            string result = dataAccess.LoginSuccess();
            MessageBox.Show(result);

            GameLobby gameLobby = new GameLobby();
            this.Hide();
            gameLobby.Show();
        }

        private void Login_Load(object sender, EventArgs e)
        {
            DataAccess dataAccess = new DataAccess();
            string result = dataAccess.LoginConnection();
            MessageBox.Show(result);
        }
    }
}
