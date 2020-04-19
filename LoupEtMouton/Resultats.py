

import matplotlib.pyplot as plt
import os
os.chdir(r'C:\Users\antoi\OneDrive\Fichiers\Programmation\Processing\Autre\Abouti\Projet-Bouffer Et Bouffeur\v2\LoupEtMouton')

numero = "Save"

fichier = open("resultats.txt","r")
f = fichier.readlines()
fichier.close()


les_t = []
les_moutons = []
les_herbes = []


for i in f:
    ligne = i.strip().split(" ")
    les_t.append(float(ligne[0]))
    les_moutons.append(float(ligne[2]))
    les_herbes.append(float(ligne[1]))
    
fig,ax1 = plt.subplots()

color = 'tab:green'
ax1.set_xlabel('Iteration')
ax1.set_ylabel('Herbe', color=color)
ax1.plot(les_t, les_herbes, color=color)
ax1.tick_params(axis='y', labelcolor=color)

ax2 = ax1.twinx()

color = 'tab:blue'
ax2.set_ylabel('Moutons', color=color)  
ax2.plot(les_t, les_moutons, color=color)
ax2.tick_params(axis='y', labelcolor=color)

fig.tight_layout()






plt.show()
    