from autocorrect import spell
import time
while 1:
	f = open('letters.txt','r');
	text = f.read();
	f.close();
	f = open('words.txt','w')
	f.write(spell(text))
	f.close()
	print spell(text)
	time.sleep(0.1)
