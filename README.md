# Wash.io 👕

Wash.io is a convenient app that allows users to book a time slot for using the washing machine on their floor. The app also sends notification alerts to remind users of their booking and keep them updated on the machine's availability.

<img src="https://cdn.discordapp.com/attachments/883222664066502716/1279666940914434101/showcase-img.png?ex=66d54635&is=66d3f4b5&hm=688f7787d7f5562a952464cbb9372d242bd425e53b5d02e11d5242dcb9d7c2e2&" alt="showcase" height="300"/>

## Features ✨

- **Time Slot Booking**: Users can easily book a time slot for using the washing machine on their floor.
- **Notification Alerts**: The app sends notifications to remind users of their upcoming bookings and notify them of any changes.
- **Real-Time Availability**: Check the real-time availability of the washing machine to find the most convenient time slot.

## Installation 💾

To run the Wash.io app locally, follow these steps:

1. Install flutter

2. Clone the repository:

   ```bash
   git clone https://github.com/KingRain/Washio.git
   cd washio
   ```

3. Enter your superbase credentials at `/lib/main.dart`
```dart
await Supabase.initialize(
      url: 'https://smth.supabase.co',
      anonKey: 'xyz', // Replace with your Supabase anonymous key
    );
```

4. Run `flutter run`

## Contributing 🦆

Clone the GitHub repo -> make changes -> submit a pull request.

## Support ☕

[Buy Me a coffee](https://buymeacoffee.com/samjoe.png)