using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace Lab1SGBD
{
    public partial class Form1 : Form
    {
        string connectionString = "Server=DESKTOP-DMHN0DR\\SQLEXPRESS;DataBase=CompanieTelefonicaBD;Integrated Security=true;";

        DataSet dataSet = new DataSet();
        SqlDataAdapter dataAdapterParent = new SqlDataAdapter();
        SqlDataAdapter dataAdapterChild = new SqlDataAdapter();

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            this.Text = "Relatie 1-n";
            label1.Text = "Tabela parinte";
            label2.Text = "Tabela fiu";
            label3.Text = "id_serviciu";
            label4.Text = "denumire";
            label5.Text = "descriere";
            label6.Text = "pret";
            label7.Text = "pret nou";
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    dataAdapterParent.SelectCommand = new SqlCommand("SELECT * FROM Sedii", connection);
                    dataAdapterParent.Fill(dataSet, "Sedii");
                    dataGridView1.DataSource = dataSet.Tables["Sedii"];

                    dataAdapterChild.SelectCommand = new SqlCommand("SELECT * FROM Servicii", connection);
                    dataAdapterChild.Fill(dataSet, "Servicii");
                    dataGridView2.DataSource = dataSet.Tables["Servicii"];
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void dataGridView1_RowHeaderMouseClick_1(object sender, DataGridViewCellMouseEventArgs e)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    if (dataSet.Tables.Contains("Servicii"))
                        dataSet.Tables["Servicii"].Clear();

                    DataGridViewRow dataGridViewRow = dataGridView1.Rows[e.RowIndex];
                    var numar_inregistrare = dataGridViewRow.Cells[0].Value;

                    dataAdapterChild.SelectCommand = new SqlCommand("SELECT * FROM Servicii WHERE Servicii.numar_inregistrare_sediu = @numar_inregistrare_sediu;", connection);
                    dataAdapterChild.SelectCommand.Parameters.AddWithValue("@numar_inregistrare_sediu", numar_inregistrare);
                    dataAdapterChild.Fill(dataSet, "Servicii");
                    dataGridView2.DataSource = dataSet.Tables["Servicii"];
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    if (dataSet.Tables.Contains("Servicii"))
                        dataSet.Tables["Servicii"].Clear();


                    connection.Open();

                    string id_serviciu = textBox1.Text;
                    DataGridViewRow dataGridViewRow = dataGridView1.Rows[e.RowIndex];
                    var id = dataGridViewRow.Cells[0].Value;
                    string denumire = textBox2.Text;
                    string descriere = textBox3.Text;
                    string pret = textBox4.Text;

                    dataAdapterChild.InsertCommand = new SqlCommand("INSERT INTO Servicii (id_serviciu, numar_inregistrare_sediu, denumire, descriere, pret) VALUES (@id_serviciu, @numar_inregistrare_sediu, @denumire, @descriere, @pret);", connection);
                    dataAdapterChild.InsertCommand.Parameters.AddWithValue("@id_serviciu", id_serviciu);
                    dataAdapterChild.InsertCommand.Parameters.AddWithValue("@numar_inregistrare_sediu", id);
                    dataAdapterChild.InsertCommand.Parameters.AddWithValue("@denumire", denumire);
                    dataAdapterChild.InsertCommand.Parameters.AddWithValue("@descriere", descriere);
                    dataAdapterChild.InsertCommand.Parameters.AddWithValue("@pret", pret);

                    MessageBox.Show("Successful insertion!");
                    dataAdapterChild.InsertCommand.ExecuteNonQuery();

                    dataAdapterChild.SelectCommand = new SqlCommand("SELECT * FROM Servicii WHERE Servicii.numar_inregistrare_sediu = @numar_inregistrare;", connection);
                    dataAdapterChild.SelectCommand.Parameters.AddWithValue("@numar_inregistrare", id);

                    dataAdapterChild.Fill(dataSet, "Servicii");
                    dataAdapterChild.Update(dataSet, "Servicii");
                    dataGridView2.DataSource = dataSet.Tables["Servicii"];
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }

        }


        private void dataGridView2_CellMouseClick(object sender, DataGridViewCellMouseEventArgs e)
        { 
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    DataGridViewRow dataGridViewRow = dataGridView2.Rows[e.RowIndex];
                    var id = dataGridViewRow.Cells[0].Value;
                    string nou = textBox5.Text;

                    dataAdapterChild.UpdateCommand = new SqlCommand("UPDATE Servicii SET pret = @pret WHERE id_serviciu = @id_serviciu;", connection);
                    dataAdapterChild.UpdateCommand.Parameters.AddWithValue("@pret", nou);
                    dataAdapterChild.UpdateCommand.Parameters.AddWithValue("@id_serviciu", id);

                    dataAdapterChild.UpdateCommand.ExecuteNonQuery();

                    if (dataSet.Tables.Contains("Servicii"))
                        dataSet.Tables["Servicii"].Clear();

                    dataAdapterChild.SelectCommand = new SqlCommand("SELECT * FROM Servicii;", connection);
                    dataAdapterChild.Fill(dataSet, "Servicii");
                    dataAdapterChild.Update(dataSet, "Servicii");
                    dataGridView2.DataSource = dataSet.Tables["Servicii"];

                    connection.Close();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void dataGridView2_RowHeaderMouseClick_1(object sender, DataGridViewCellMouseEventArgs e)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    DataGridViewRow dataGridViewRow = dataGridView2.Rows[e.RowIndex];
                    var id = dataGridViewRow.Cells[0].Value;
                    dataAdapterChild.DeleteCommand = new SqlCommand("DELETE FROM Servicii WHERE id_serviciu = @id_serviciu;", connection);
                    dataAdapterChild.DeleteCommand.Parameters.AddWithValue("@id_serviciu", id);

                    MessageBox.Show("Successful deleted!");
                    dataAdapterChild.DeleteCommand.ExecuteNonQuery();

                    if (dataSet.Tables.Contains("Servicii"))
                        dataSet.Tables["Servicii"].Clear();

                    dataAdapterChild.SelectCommand = new SqlCommand("SELECT * FROM Servicii;", connection);
                    dataAdapterChild.Fill(dataSet, "Servicii");
                    dataAdapterChild.Update(dataSet, "Servicii");
                    dataGridView2.DataSource = dataSet.Tables["Servicii"];

                    connection.Close();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
    }
}
