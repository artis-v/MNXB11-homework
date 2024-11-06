#include <TROOT.h>

#include <iostream>

void rootlogon() {
    gROOT->LoadMacro("momentum.cxx");
    gROOT->LoadMacro("write.cxx");
    gROOT->LoadMacro("read.cxx");
}