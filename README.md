# dart-decoder
D.A.R.T. (HPLHS) brute force decoding.

## What is this nonsense?

The Dark Action Radio Theatre has a "secret decoder" club. It's cool. However, as a programmer
I'm more interested in decomposing the problem.

Traditionally with a Caesar Cipher, one has an initial key that one starts with to "seed" the
decoding algorithm.

Since we're using far more powerful computers, I thought that was a complete waste of time.

Instead, this creates 26 potential messages, and then uses a dictionary of all english words
to determine what the most likely message would be.

## Future State

I'd like to incorporate character detection to determine what numbers are "seen" in a given
message.

I'd like better structure to the playground, so that I'm not commenting things in and out
to provide a new message.
