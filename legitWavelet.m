clear all, close all, clc
A = imread("Bliss.png");
B = rgb2gray(A);


n = 2; w = 'db1'; [C, S] = wavedec2(B,n,w);


A1 = appcoef2(C, S, w, 1);