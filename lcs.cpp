#include<bits/stdc++.h>
using namespace std;

string lcs(string a, string b) {
  if (a.empty() || b.empty()) return string();
  string a_cut = a.substr(0, a.length() - 1);
  string b_cut = b.substr(0, b.length() - 1);
  if (a.back() == b.back()) return lcs(a_cut, b_cut) + a.back();
  string x = lcs(a, b_cut);
  string y = lcs(a_cut, b);

  if (x.length() > y.length()) return x;
  else return y;
}

int main() {
  ios_base::sync_with_stdio(false);
  cin.tie(NULL);

  string a, b, result;
  cin >> a >> b;
  result = lcs(a, b);
  cout << result.length() << endl << result << endl;
  return 0;
}

