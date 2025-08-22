// This class will hold all the generated data for the Station 1 result.
class PartnerTraits {
  final String height;
  final String weight;
  final String eyeColor;
  final String hobbies;
  final List<String> funnyQuirks;

  PartnerTraits({
    required this.height,
    required this.weight,
    required this.eyeColor,
    required this.hobbies,
    required this.funnyQuirks,
  });

  // A factory to generate placeholder data.
  // Later, this logic can be made more complex based on user input.
  factory PartnerTraits.generate() {
    return PartnerTraits(
      height: "180 cm",
      weight: "75 kg",
      eyeColor: "Hazel",
      hobbies: "Gaming & Art",
      funnyQuirks: [
        "Hates putting ketchup on a burger.",
        "Can name every single Pokémon.",
        "Sings loudly, but only in the car.",
      ],
    );
  }
}