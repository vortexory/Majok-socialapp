// This class defines the structure of our user's data.
class UserProfile {
  final String name;
  final int age;
  final int height;
  final String gender;
  final List<String> hobbies;
  final String? photoUrl; // For later use

  UserProfile({
    required this.name,
    required this.age,
    required this.height,
    required this.gender,
    required this.hobbies,
    this.photoUrl,
  });

  // A factory for creating a default/placeholder profile
  factory UserProfile.placeholder() {
    return UserProfile(
      name: "John Smith",
      age: 30,
      height: 175,
      gender: "Male",
      hobbies: ["Reading", "Cycling"],
    );
  }

  // Helper to get initials from name
  String get initials {
    if (name.isEmpty) return "??";
    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      return parts[0][0].toUpperCase() + parts.last[0].toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}