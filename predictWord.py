from autocorrect import spell
import time
while 1:
	f = open('letters.txt','r');
	text = f.read();
	print text
	print spell(text)
	f.close();
	f = open('word.txt','w')
	f.write(spell(text))
	f.close()
	time.sleep(0.1)
