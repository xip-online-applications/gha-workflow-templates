test-git-crypt-unlock:
	docker build -t git-crypt-unlock ./git-crypt-unlock
	docker run --workdir /github/workspace -v "$(CURDIR):/github/workspace" git-crypt-unlock "AEdJVENSWVBUS0VZAAAAAgAAAAAAAAABAAAABAAAAAAAAAADAAAAIISRqM2u8HMJg4Ev4IoJD9BG2qlfa6Pza8zhgZwipLOoAAAABQAAAEDZcLaTmNYQgiB+Hkjfr/lscNrNrl/fDQ2bDPPdHXLf7myTY3Xa1gujDGyrVKR8qQSl/r2JtOzyX6mx526BDkjTAAAAAA=="
