int main() {

	float i = 4711.32; float j = 1.2;
	float res = 0.0;
	
	for(int x = 0; x < 10; x++){
		res = i++ / j++;
	}

	return 0;
}
