import os
import smtplib
from email.message import EmailMessage

email = "roldanramon83@gmail.com"

senha_do_email = "gdcryxilokwfjknk"

msg = EmailMessage()
msg['Subject']  = 'Enviando e-mail com Python'
msg['From'] = 'roldanramon83@gmail.com'
msg['To'] = 'roldanramon83@gmail.com'
msg.set_content("Segue o relatório diário")

with open('fiis.csv', 'rb') as content_file:
    content = content_file.read()
    msg.add_attachment(content, maintype='application', subtype='csv', filename='fiis.csv')
    
with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp:
    
    smtp.login(email, senha_do_email)
    smtp.send_message(msg)
