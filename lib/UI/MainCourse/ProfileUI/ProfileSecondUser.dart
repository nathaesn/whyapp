import 'package:flutter/material.dart';

class profileUserSecond extends StatefulWidget {
  const profileUserSecond({super.key});

  @override
  State<profileUserSecond> createState() => _profileUserSecondState();
}

class _profileUserSecondState extends State<profileUserSecond> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Hero(
                tag: 'photo-profile-chat',
                child: Image.network(
                  "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/d2cd2085-496f-407f-b79b-7b436edd816a/df8u4a7-1a6eafb7-4bc4-4a4e-a7f8-f65a3f38a20f.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcL2QyY2QyMDg1LTQ5NmYtNDA3Zi1iNzliLTdiNDM2ZWRkODE2YVwvZGY4dTRhNy0xYTZlYWZiNy00YmM0LTRhNGUtYTdmOC1mNjVhM2YzOGEyMGYuanBnIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.fpKCkMz_jDn4GGV0F0KmS2fsEufaPLV8YJQjQ_xTEsc",
                  width: double.infinity,
                ))
          ],
        ),
      ),
    );
  }
}
