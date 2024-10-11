#include <iostream>
#include <string>

using std::string, std::cout, std::endl, std::atoi;

int character_sum(string str) {
    int sum{0};
    for (int i = 0; i < static_cast<int>(str.size()); ++i) {
        sum += str[i];
    }
    return sum;
}

int key(int char_sum, char first_letter, int name_length) {
    return (char_sum ^ first_letter * 3) << (name_length & 0x1f);
}

void console_response(int calculated_key, int expected_key) {
    cout << "Calculated key: " << calculated_key << endl;
    cout << "Expected key: " << expected_key << endl;
    if (expected_key == 0) {
        cout << "NOTE: expected key defaults to 0 if the input is not an "
                "integer; verify that the expected key is as intended."
             << endl;
    }
    if (calculated_key == expected_key) {
        cout << "Correct!" << endl;
    } else {
        cout << "Wrong!" << endl;
    }
}

int main(int num_of_args, char *args[]) {
    if (num_of_args != 3) {
        cout << "Incorrect number of arguments. Do:" << endl;
        cout << "./executable phrase expected_key" << endl;
    } else {
        string executable_name{args[0]};
        char phrase_first_letter{*(args[1])};
        int executable_name_len{static_cast<int>(executable_name.size())};
        int expected_key{atoi(args[2])};
        string phrase{args[1]};
        int phrase_char_sum = character_sum(phrase);
        int calculated_key =
            key(phrase_char_sum, phrase_first_letter, executable_name_len);
        console_response(calculated_key, expected_key);
    }
}