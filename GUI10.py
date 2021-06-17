from tkinter import *
from tkinter import ttk

from matplotlib.backends.backend_tkagg import (
    FigureCanvasTkAgg, NavigationToolbar2Tk)


from matplotlib.figure import Figure
import matplotlib.pyplot as plt
import numpy as np
from math import *

""" 
    Program rysuje wykres dowolnej funcji. 
    Do interfejsu graficznego wykorzystuje standardową bibliotekę tkinter. 
    Wywoływany z terminala.
    
"""     

root = Tk()
root.title("Generating the graphs of a function") #ustawia tytuł
root.geometry('550x830')                          #ustawia wymiary

#!/usr/bin/env python
e = Entry(root, width = 35, borderwidth = 5)                  #tworzenie pola tekstowego do wpisywania funkcji          
e.grid(row = 0, column = 1, pady = 2, padx=2,columnspan = 2)
e.insert(0,"x")

l1 = Label(root, text = "f(x) =",pady = 5, padx = 2) 
l1.grid(row = 0 , column = 0,sticky = W,pady = 2)
   
def Button_click(marks):             #funckja dodająca argument marks, uruchamiana po kliknięciu odpowiedniego buttona
    current = e.get()
    e.delete(0,END)
    e.insert(0,current + marks)
 

 #definiowanie "buttons"
button_1 = Button(root, text = "*", padx = 40, pady = 20, command = lambda: Button_click("*"))
button_2 = Button(root, text = "^", padx = 40, pady = 20, command = lambda: Button_click("**"))
button_3 = Button(root, text = "(", padx = 40, pady = 20, command = lambda: Button_click("("))
button_4 = Button(root, text = ")", padx = 40, pady = 20, command = lambda: Button_click(")"))
button_5 = Button(root, text = "+", padx = 40, pady = 20, command = lambda: Button_click("+"))
button_6 = Button(root, text = "-", padx = 40, pady = 20, command = lambda: Button_click("-"))
button_7 = Button(root, text = "sin", padx = 37, pady = 20, command = lambda: Button_click("sin(x)"))
button_8 = Button(root, text = ";", padx = 40, pady = 20, command = lambda: Button_click(";"))

#umiejscowienie "buttons" na ekranie 
button_1.grid(row = 2, column = 1)
button_2.grid(row = 2, column = 2)
button_3.grid(row = 3, column = 1)

button_4.grid(row = 3, column = 2)
button_5.grid(row = 4, column = 1)
button_6.grid(row = 4, column = 2)
button_7.grid(row = 5, column = 1)
button_8.grid(row = 5, column = 2)


#definiowanie tytułów, "labels"
l4 = Label(root, text = "min x",pady = 5, padx = 2) 
l5 = Label(root,text = "max x",pady = 2, padx = 2)

l6 = Label(root, text = "min y",pady = 5, padx = 2)
l7 = Label(root, text = "max y",pady = 5, padx = 2) 

l8 = Label(root,text = "title",pady = 2, padx = 2)
l9 = Label(root, text = "legend x",pady = 5, padx = 2)
l10 = Label(root, text = "legend y",pady = 5, padx = 2) 

#tworzenie pola tekstowego dla odpowiednich tytułów,"l"  oraz ustawianie wartości domyślnej
g4 = Entry(root) 
g4.insert(0,"-10.0")

g5 = Entry(root)
g5.insert(0,"10.0")

g6 = Entry(root)
g6.insert(0,"-10.0")

g7 = Entry(root) 
g7.insert(0,"10.0")

g8 = Entry(root)
g8.insert(0,"title")

g9 = Entry(root)
g9.insert(0,"x")

g10 = Entry(root) 
g10.insert(0,"y")
                                                #umiejscowienie tytułów i pól tekstowych na ekranie 
l4.grid(row = 0 , column = 4,)
g4.grid(row = 0 , column = 5, sticky = W)

l5.grid(row = 1 , column = 4,)
g5.grid(row = 1 , column = 5, sticky = W)

l6.grid(row = 2 , column = 4,)
g6.grid(row = 2 , column = 5, sticky = W)

l7.grid(row = 3 , column = 4,)
g7.grid(row = 3 , column = 5, sticky = W)

l8.grid(row = 4 , column = 4,)
g8.grid(row = 4 , column = 5, sticky = W)

l9.grid(row = 5 , column = 4,)
g9.grid(row = 5 , column = 5, sticky = W)

l10.grid(row = 6 , column = 4,)
g10.grid(row = 6 , column = 5, sticky = W)
                                             #definiuję przycisk checkbutton i umiejscawiam na ekranie 
CheckVar1 = IntVar()
legendbutton = ttk.Checkbutton(root, text = "If Legend",variable = CheckVar1,onvalue = 1, offvalue=0)
legendbutton.grid(row=7,column = 4, columnspan = 2)


def _quit():             #funkcja zamykająca GUI
    root.quit()     
    root.destroy()  
                    
        
        
def _plot():              #funckja rysująca wykresy
    
    
    x_min = float(g4.get())
    x_max = float(g5.get())
    y_min = float(g6.get())
    y_max = float(g7.get())
    title = g8.get()
    x_label = g9.get()
    y_label = g10.get()
    
    
    listaf = e.get().split(";")        #pobiera pole tekstowe ze wzorami funkcji, a następnie tworzy listę z poszczególnymi funkcjami
    
    
    
    
    fig = Figure(figsize=(5, 4), dpi=100)      #definiuję "figurę" 
    x = np.linspace(x_min, x_max, 100)
    ax = fig.add_subplot(111)                  #do "figury" dodaje wykres
    for func in listaf:
        f_vec = np.vectorize(lambda x:eval(func))   #eval, dostaje string, który odczytuje jak zwykle liczby
        y = f_vec(x)
        ax.plot(x,y, label = func)
    
    if CheckVar1.get() == 1:      
        ax.legend()
    ax.set_title(title)
    ax.set_xlabel(x_label)
    ax.set_ylabel(y_label)
    ax.axis([x_min,x_max,y_min,y_max])
    
    # umieszczam "płótno" z wykresem na ekranie w GUI
    canvas = FigureCanvasTkAgg(fig, master=root)  
    canvas.get_tk_widget().grid(row = 12,column = 0, columnspan= 7)
    canvas.draw()


#umiejscawiam przycisk "Quit"

buttonq = Button(master=root, text="Quit", command=_quit,padx = 40, pady = 20)
buttonq.grid(row = 10, column = 2)

#umiejscawiam przycisk "Plot"

buttond = Button(master=root, text="Plot", command=_plot,padx = 40, pady = 20)
buttond.grid(row = 10, column = 4)


root.mainloop()

  