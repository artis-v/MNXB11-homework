#include <TFile.h>
#include <TRandom.h>
#include <TTree.h>

#include "momentum.h"

void write() {
    Momentum *momentum{};

    TFile f("tree_file.root", "RECREATE");

    TTree *T = new TTree("T", "demo tree");

    T->Branch("Momentum", &momentum);

    Float_t px, py, pz;

    for (Int_t ev{0}; ev < 10000; ev++) {
        px = gRandom->Gaus(0, .02);
        py = gRandom->Gaus(0, .02);
        pz = gRandom->Gaus(0, .02);

        momentum = new Momentum(ev, px, py, pz);

        T->Fill();

        delete momentum;
    }

    T->AutoSave();
}