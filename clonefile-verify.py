#!/usr/bin/env python3
import sqlite3, subprocess, platform

conn = sqlite3.connect('clonefile-index.sqlite')

with conn:

	cur = conn.cursor()

	cur.execute("SELECT chksumfull, COUNT(*) c FROM files WHERE chksumfull != '' GROUP BY chksumfull HAVING c > 1")
	results = cur.fetchall()
	pf = platform.system()
	if pf != 'Darwin':
		sha_cmd = ['shasum', '-a', '256']
	elif pf != "Linux":
		sha_cmd = ['sha256sum']
	else:
		exit(1)
	for result in results:
		dupscur = conn.cursor()
		dupscur.execute("SELECT file FROM files WHERE chksumfull = ?", (result[0],) )
		# print(result)
		dupesResults = dupscur.fetchall()
		fileIndex = 0
		for dupesResult in dupesResults:
			print("Verifying file: " + dupesResult[0])
			chksumRaw = subprocess.run(sha_cmd + [dupesResult[0]], stdout=subprocess.PIPE)
			chksum = chksumRaw.stdout.split()[0].decode("utf-8")
			print("Original checksum: \t \t "+ result[0])
			print("New file: \t \t \t "+ chksum)
			# I should probably add some logic here to ignore Spotlight search files. 
			if chksum == result[0]:
				print("\033[1;32mVerified!!\033[1;m")
			else:
				input("Failed to verify: " + dupesResult[0])

conn.close()
