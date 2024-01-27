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
using System.Configuration;

namespace Lab1SGBD
{
    public partial class Form1 : Form
    {

        SqlConnection sqlConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["connectingString"].ConnectionString);

        DataSet dataSet = new DataSet();
        SqlDataAdapter dataAdapterParent = new SqlDataAdapter();
        SqlDataAdapter dataAdapterChild = new SqlDataAdapter();

        string childTableName = ConfigurationManager.AppSettings["ChildTableName"];
		string childColumnNames = ConfigurationManager.AppSettings["ChildColumnNames"];


        public Form1()
        {
            InitializeComponent();
        }


        private void Form1_Load(object sender, EventArgs e)
        {
            this.Text = ConfigurationManager.AppSettings["title"];
            label1.Text = ConfigurationManager.AppSettings["label1"] + ": " + ConfigurationManager.AppSettings["ParentTableName"];
            label2.Text = ConfigurationManager.AppSettings["label2"] + ": " + ConfigurationManager.AppSettings["ChildTableName"];
            label3.Text = ConfigurationManager.AppSettings["label3"];
            label4.Text = ConfigurationManager.AppSettings["label4"];
            label5.Text = ConfigurationManager.AppSettings["label5"];
            label6.Text = ConfigurationManager.AppSettings["label6"];
            label7.Text = ConfigurationManager.AppSettings["label7"];

            try
            {
                string conn = ConfigurationManager.ConnectionStrings["connectingString"].ConnectionString;
                SqlConnection connection = new SqlConnection(conn);
               
                connection.Open();

                string selectParent = ConfigurationSettings.AppSettings["selectParent"];
                dataAdapterParent.SelectCommand = new SqlCommand(selectParent, connection);
                dataAdapterParent.Fill(dataSet, "ParentTableName");
                dataGridView1.DataSource = dataSet.Tables["ParentTableName"];

                string selectChild = ConfigurationSettings.AppSettings["selectChild"];
                dataAdapterChild.SelectCommand = new SqlCommand(selectChild, connection);
                dataAdapterChild.Fill(dataSet, "ChildTableName");
                dataGridView2.DataSource = dataSet.Tables["ChildTableName"];}
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void dataGridView1_RowHeaderMouseClick_1(object sender, DataGridViewCellMouseEventArgs e)
        {
            try
            {
                string conn = ConfigurationManager.ConnectionStrings["connectingString"].ConnectionString;
                SqlConnection connection = new SqlConnection(conn);

                dataSet.Tables["ChildTableName"].Clear();

                DataGridViewRow dataGridViewRow = dataGridView1.Rows[e.RowIndex];
                var index = dataGridViewRow.Cells[0].Value;

                string selectSpecial = ConfigurationSettings.AppSettings["selectSpecial"];
                dataAdapterChild.SelectCommand = new SqlCommand(selectSpecial, connection);
                dataAdapterChild.SelectCommand.Parameters.AddWithValue(ConfigurationManager.AppSettings["legatura"], SqlDbType.Int).Value = index;
                dataAdapterChild.Fill(dataSet, "ChildTableName");
                dataGridView2.DataSource = dataSet.Tables["ChildTableName"];
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
                string conn = ConfigurationManager.ConnectionStrings["connectingString"].ConnectionString;
                SqlConnection connection = new SqlConnection(conn);

                connection.Open();
                string ChildTableName = ConfigurationManager.AppSettings["ChildTableName"];
                string ColumnNamesInsertParameters = ConfigurationManager.AppSettings["ColumnNamesInsertParameters"];
                dataAdapterChild.InsertCommand = new SqlCommand("INSERT INTO " + ChildTableName + " VALUES (" + ColumnNamesInsertParameters + ");", connection);


                //DataGridViewRow dataGridViewRow = dataGridView1.Rows[e.RowIndex];
                //var legaturaText = dataGridViewRow.Cells[0].Value;
                
                //for (int i = 1; i <= int.Parse(ConfigurationManager.AppSettings["ColumnNumber"]); i++)
                //{
                //    TextBox textBox = new TextBox();
                //    if (i == 2)
                //        textBox.Name = (string)(legaturaText = ConfigurationManager.AppSettings[i.ToString()]);
                //    else
                //        textBox.Name = textBox.Text = ConfigurationManager.AppSettings[i.ToString()];
                //    panel1.Controls.Add(textBox);
                //}

                string stringText1 = textBox1.Text;
                DataGridViewRow dataGridViewRow = dataGridView1.Rows[e.RowIndex];
                var legaturaText = dataGridViewRow.Cells[0].Value;
                string stringText2 = textBox2.Text;
                string stringText3 = textBox3.Text;
                string stringText4 = textBox4.Text;
                string stringText5 = textBox5.Text; 

                string string1 = ConfigurationManager.AppSettings["string1"];
                string legatura = ConfigurationManager.AppSettings["legatura"];
                string string2 = ConfigurationManager.AppSettings["string2"];
                string string3 = ConfigurationManager.AppSettings["string3"];
                string string4 = ConfigurationManager.AppSettings["string4"];
                string string5 = ConfigurationManager.AppSettings["string5"]; 

                dataAdapterChild.InsertCommand.Parameters.AddWithValue(string1, stringText1);
                dataAdapterChild.InsertCommand.Parameters.AddWithValue(legatura, legaturaText);
                dataAdapterChild.InsertCommand.Parameters.AddWithValue(string2, stringText2);
                dataAdapterChild.InsertCommand.Parameters.AddWithValue(string3, stringText3);
                dataAdapterChild.InsertCommand.Parameters.AddWithValue(string4, stringText4);
                dataAdapterChild.InsertCommand.Parameters.AddWithValue(string5, stringText5); 

                dataAdapterChild.InsertCommand.ExecuteNonQuery();
                MessageBox.Show("Inserted Succesfull to the Database");

                dataSet.Tables["ChildTableName"].Clear();

                string selectSpecial = ConfigurationSettings.AppSettings["selectSpecial"];
                dataAdapterChild.SelectCommand.Parameters.AddWithValue(ConfigurationManager.AppSettings["legatura"], SqlDbType.Int).Value = ConfigurationManager.AppSettings["legatura"]; ;
               
                dataAdapterChild.Fill(dataSet, "ChildTableName");
                dataAdapterChild.Update(dataSet, "ChildTableName");
                dataGridView2.DataSource = dataSet.Tables["ChildTableName"];
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
                string conn = ConfigurationManager.ConnectionStrings["connectingString"].ConnectionString;
                SqlConnection connection = new SqlConnection(conn);
                connection.Open();

                DataGridViewRow dataGridViewRow = dataGridView2.Rows[e.RowIndex];
                var id = dataGridViewRow.Cells[0].Value;

                string delete = ConfigurationSettings.AppSettings["delete"];
                dataAdapterChild.DeleteCommand = new SqlCommand(delete, connection);

                string string1 = ConfigurationManager.AppSettings["string1"];
                dataAdapterChild.DeleteCommand.Parameters.AddWithValue(string1, id);

                dataAdapterChild.DeleteCommand.ExecuteNonQuery();

                dataSet.Tables["ChildTableName"].Clear();

                string selectChild = ConfigurationSettings.AppSettings["selectChild"];
                dataAdapterChild.SelectCommand = new SqlCommand(selectChild, connection);
                dataAdapterChild.Fill(dataSet, "ChildTableName");
                dataAdapterChild.Update(dataSet, "ChildTableName");
                dataGridView2.DataSource = dataSet.Tables["ChildTableName"];
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
                string conn = ConfigurationManager.ConnectionStrings["connectingString"].ConnectionString;
                SqlConnection connection = new SqlConnection(conn);
                connection.Open();

                DataGridViewRow dataGridViewRow = dataGridView2.Rows[e.RowIndex];
                var stringText1 = dataGridViewRow.Cells[0].Value;   
                string stringText5 = textBox5.Text; 

                string update = ConfigurationSettings.AppSettings["update"];
                dataAdapterChild.UpdateCommand = new SqlCommand(update, connection);

                string string1 = ConfigurationManager.AppSettings["string1"];
                string string5 = ConfigurationManager.AppSettings["string5"]; 

                dataAdapterChild.UpdateCommand.Parameters.AddWithValue(string5, stringText5); 
                dataAdapterChild.UpdateCommand.Parameters.AddWithValue(string1, stringText1);

                dataAdapterChild.UpdateCommand.ExecuteNonQuery();

                dataSet.Tables["ChildTableName"].Clear();

                string selectChild = ConfigurationSettings.AppSettings["selectChild"];
                dataAdapterChild.SelectCommand = new SqlCommand(selectChild, connection);
                dataAdapterChild.Fill(dataSet, "ChildTableName");
                dataAdapterChild.Update(dataSet, "ChildTableName");
                dataGridView2.DataSource = dataSet.Tables["ChildTableName"];
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
    }
}
