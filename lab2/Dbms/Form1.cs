using System;
using System.Data;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Configuration;

namespace Dbms
{
    public partial class Form1 : Form
    {
        private SqlConnection connection;
        private DataSet ds;
        private SqlDataAdapter daChild, daParent;
        private SqlCommandBuilder cmdBuilder;
        BindingSource bsChild, bsParent;

        public Form1()
        {
            InitializeComponent();

        }

        public static String GetConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["ConnectionStringDB"].ConnectionString.ToString();
        }

        private void Connect_Click(object sender, EventArgs e)
        {
            connection = new SqlConnection(GetConnectionString());
            ds = new DataSet();

            daChild = new SqlDataAdapter(ConfigurationManager.AppSettings["selectAllChildren"], connection);
            daParent = new SqlDataAdapter(ConfigurationManager.AppSettings["selectAllParents"], connection);
            
            cmdBuilder = new SqlCommandBuilder(daChild);

            daChild.Fill(ds, ConfigurationManager.AppSettings["childTableName"]);
            daParent.Fill(ds, ConfigurationManager.AppSettings["parentTableName"]);

            DataRelation dr = new DataRelation("fk_parent_child",
                ds.Tables[ConfigurationManager.AppSettings["parentTableName"]].Columns[ConfigurationManager.AppSettings["parentColPK"]],
                ds.Tables[ConfigurationManager.AppSettings["childTableName"]].Columns[ConfigurationManager.AppSettings["childColFK"]]
                );
            ds.Relations.Add(dr);

            bsParent = new BindingSource();
            bsChild = new BindingSource();

            //bind parent table tp gridview
            bsParent.DataSource = ds;
            bsParent.DataMember = ConfigurationManager.AppSettings["parentTableName"];
             
            //bind child table tp gridview
            bsChild.DataSource = bsParent;
            bsChild.DataMember = "fk_parent_child";

            mechanicsGridView.DataSource = bsChild;
            managersGridView.DataSource = bsParent;


        }

        private void Update_Click(object sender, EventArgs e)
        {
            try
            {
                daChild.Update(ds, ConfigurationManager.AppSettings["childTableName"]);
                MessageBox.Show("Succesful update to the database!");
            }
            catch (Exception ex)
            {
                MessageBox.Show("This update is not possible because of other constraints!");
            }



        }



    }
}
 