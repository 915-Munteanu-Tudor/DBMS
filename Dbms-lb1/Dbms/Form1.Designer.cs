﻿namespace Dbms
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.ConnectDb = new System.Windows.Forms.Button();
            this.mechanicsGridView = new System.Windows.Forms.DataGridView();
            this.managersGridView = new System.Windows.Forms.DataGridView();
            this.UpdateDb = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.mechanicsGridView)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.managersGridView)).BeginInit();
            this.SuspendLayout();
            // 
            // ConnectDb
            // 
            this.ConnectDb.Location = new System.Drawing.Point(312, 30);
            this.ConnectDb.Name = "ConnectDb";
            this.ConnectDb.Size = new System.Drawing.Size(77, 21);
            this.ConnectDb.TabIndex = 0;
            this.ConnectDb.Text = "Connect";
            this.ConnectDb.UseVisualStyleBackColor = true;
            this.ConnectDb.Click += new System.EventHandler(this.Connect_Click);
            // 
            // mechanicsGridView
            // 
            this.mechanicsGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.mechanicsGridView.Location = new System.Drawing.Point(12, 57);
            this.mechanicsGridView.Name = "mechanicsGridView";
            this.mechanicsGridView.Size = new System.Drawing.Size(543, 311);
            this.mechanicsGridView.TabIndex = 1;
            // 
            // managersGridView
            // 
            this.managersGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.managersGridView.Location = new System.Drawing.Point(572, 57);
            this.managersGridView.Name = "managersGridView";
            this.managersGridView.Size = new System.Drawing.Size(244, 311);
            this.managersGridView.TabIndex = 2;
            // 
            // UpdateDb
            // 
            this.UpdateDb.Location = new System.Drawing.Point(395, 30);
            this.UpdateDb.Name = "UpdateDb";
            this.UpdateDb.Size = new System.Drawing.Size(76, 21);
            this.UpdateDb.TabIndex = 3;
            this.UpdateDb.Text = "Update";
            this.UpdateDb.UseVisualStyleBackColor = true;
            this.UpdateDb.Click += new System.EventHandler(this.Update_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(9, 34);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(89, 13);
            this.label1.TabIndex = 4;
            this.label1.Text = "Mechanics Table";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(569, 34);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(84, 13);
            this.label2.TabIndex = 5;
            this.label2.Text = "Managers Table";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(828, 380);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.UpdateDb);
            this.Controls.Add(this.managersGridView);
            this.Controls.Add(this.mechanicsGridView);
            this.Controls.Add(this.ConnectDb);
            this.Name = "Form1";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.mechanicsGridView)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.managersGridView)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button ConnectDb;
        private System.Windows.Forms.DataGridView mechanicsGridView;
        private System.Windows.Forms.DataGridView managersGridView;
        private System.Windows.Forms.Button UpdateDb;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
    }
}

