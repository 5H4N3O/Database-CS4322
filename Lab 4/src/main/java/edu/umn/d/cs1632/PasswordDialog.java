/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.umn.d.cs1632;

import java.awt.FlowLayout;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JPasswordField;

/**
 *
 */
public class PasswordDialog extends JPanel {
  private final JPasswordField passwordField = new JPasswordField(12);
  private boolean gainedFocusBefore;

  /**
   * "Hook" method that causes the JPasswordField to request focus the first time this method is called.
   */
  void gainedFocus() {
    if (!gainedFocusBefore) {
      gainedFocusBefore = true;
      passwordField.requestFocusInWindow();
    }
  }

  public PasswordDialog() {
    super(new FlowLayout());

    add(new JLabel("Password: "));
    add(passwordField);
  }

  public char[] getPassword() {
      return passwordField.getPassword();
  }
  
  public static String showPasswordDialog() {
      PasswordDialog pPnl = new PasswordDialog();
      JOptionPane op = new JOptionPane(pPnl, JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);

      JDialog dlg = op.createDialog("Password Dialog");

      // Wire up FocusListener to ensure JPasswordField is able to request focus when the dialog is first shown.
      dlg.addWindowFocusListener(new WindowAdapter() {
        @Override
        public void windowGainedFocus(WindowEvent e) {
            pPnl.gainedFocus();
        }
      });
      dlg.setVisible(true);

      String password = null;
      
      if (op.getValue() != null && op.getValue().equals(JOptionPane.OK_OPTION)) {
          password = new String(pPnl.getPassword());
      }
      
      return password;
  }
    
}