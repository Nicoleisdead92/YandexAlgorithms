#include <iostream>
#include <unordered_set>
#include <fstream>
using namespace std;

void string_to_dictionary(const string& str, unordered_set <string>& dictionary) {
    string tmp;
    for (char i : str) {
        if (i != ' ') {
            tmp += i;
        } else {
            dictionary.insert(tmp);
            tmp.clear();
        }
    }
    dictionary.insert(tmp);
}

void solution (const string& str, const unordered_set <string>& dictionary) {
    string tmp;
    bool find = false;
    for (int i = 0; i < str.size(); ++i) {
        if (str[i] != ' ') {
            find = false;
            tmp += str[i];
            auto it = dictionary.find(tmp);
            if (it != dictionary.end()) {
                find = true;
                cout << *it << " ";
                tmp.clear();
                while (str[i] != ' ' && i < str.size()) {
                    ++i;
                }
            }
        } else {
            cout << tmp << " ";
            tmp.clear();
        }
    }
    if (!find) {
        cout << tmp;
    }
}

int main() {
    string str1,str2;
    ifstream file("input.txt");
    getline(file,str1);
    getline(file,str2);
    unordered_set <string> dictionary;
    string_to_dictionary(str1,dictionary);
    solution(str2,dictionary);
    return 0;
}
