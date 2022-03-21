using System;
using System.Data;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace Dbms
{
    public partial class Form1 : Form
    {
        private SqlConnection connection;
        private DataSet ds;
        private SqlDataAdapter daMechanics, daManagers;
        private SqlCommandBuilder cmdBuilder;
        BindingSource bsMechanics, bsManagers;

        public Form1()
        {
            InitializeComponent();

        }

        public static String GetConnectionString()
        {
            return "Data Source=PT;Initial Catalog=master;Integrated Security=True";
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void Connect_Click(object sender, EventArgs e)
        {
            connection = new SqlConnection(GetConnectionString());
            ds = new DataSet();

            daMechanics = new SqlDataAdapter("select * from Mechanics", connection);
            daManagers = new SqlDataAdapter("select * from Managers", connection);
            
            cmdBuilder = new SqlCommandBuilder(daMechanics);

            daMechanics.Fill(ds, "Mechanics");
            daManagers.Fill(ds, "Managers");

            DataRelation dr = new DataRelation("FK_Managers_Mechanics",
                ds.Tables["Managers"].Columns["id_manager"],
                ds.Tables["Mechanics"].Columns["coordinator_manager"]
                );
            ds.Relations.Add(dr);

            bsManagers = new BindingSource();
            bsMechanics = new BindingSource();

            //bind parent table tp gridview
            bsManagers.DataSource = ds;
            bsManagers.DataMember = "Managers";

            //bind child table tp gridview
            bsMechanics.DataSource = bsManagers;
            bsMechanics.DataMember = "FK_Managers_Mechanics";

            mechanicsGridView.DataSource = bsMechanics;
            managersGridView.DataSource = bsManagers;

        }

        private void Update_Click(object sender, EventArgs e)
        {
            try
            {
                daMechanics.Update(ds, "Mechanics");
                MessageBox.Show("Succesful update to the database!");
            }
            catch (Exception ex)
            {
                MessageBox.Show("This update is not possible because of other constraints!");
            }



        }



    }
}
