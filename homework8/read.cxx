#include <TFile.h>
#include <TH2.h>
#include <TTree.h>
#include <TCanvas.h>

#include <iostream>

#include "momentum.h"

void read() {
    Momentum *momentum{};

    auto file = TFile::Open("tree_file.root");

    TTree *tree = static_cast<TTree *>(file->Get("T"));

    tree->SetBranchAddress("Momentum", &momentum);

    Int_t N = tree->GetEntries();

    TH2F *h1 = new TH2F("h1", "px and py for momentum;px;py", 7, -0.1, 0.1, 7,
                        -0.1, 0.1);
    for (Int_t i{0}; i < N; i++) {
        tree->GetEntry(i);
        h1->Fill(momentum->px, momentum->py);
    }

    TCanvas *c = new TCanvas("c", "Graphs", 1000, 400);
    c->Divide(2, 1);

    c->cd(1);
    h1->Draw();

    c->cd(2);
    tree->Draw("pz : px * py", "mag > 0.03");

    c->Update();
}