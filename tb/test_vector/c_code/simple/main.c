int fact (int n){
    if (n < 1) return (1);
    else return (n + fact(n-1));
}

int fact2 (int n){
	return n;
}

int main() {
	int pram = 5;
	int a = fact(pram);	
	int i;
	int c = 1;
	for (i = pram; i > 0; i--)
	{
		c += i;
	}
	if ( a != c)
		return 0;
	else	return 1;
}
