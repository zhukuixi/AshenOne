# -*- coding: utf-8 -*-
"""
Created on Thu Aug 11 17:08:54 2022

@author: Kuixi Zhu
"""
import gradio as gr

def greet(name):
    return "Hello " + name + "!!"

iface = gr.Interface(fn=greet, inputs="text", outputs="text")
iface.launch()