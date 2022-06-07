using Plugin.Settings;
using Plugin.Settings.Abstractions;

namespace Todorin.Helpers
{
    public static class Settings
    {
        private static ISettings AppSettings => CrossSettings.Current;

        public static string FirstName
        {
            get => AppSettings.GetValueOrDefault("@FirstName", "");
            set => AppSettings.AddOrUpdateValue("@FirstName", value);
        }

        public static string LastName
        {
            get => AppSettings.GetValueOrDefault("@LastName", "");
            set => AppSettings.AddOrUpdateValue("@LastName", value);
        }

        public static string Email
        {
            get => AppSettings.GetValueOrDefault("@Email", "");
            set => AppSettings.AddOrUpdateValue("@Email", value);
        }

        public static string JwtToken
        {
            get => AppSettings.GetValueOrDefault("@JwtToken", "");
            set => AppSettings.AddOrUpdateValue("@JwtToken", value);
        }

        public static int SortingMode
        {
            get => AppSettings.GetValueOrDefault("@SortingMode", 0);
            set => AppSettings.AddOrUpdateValue("@SortingMode", value);
        }

        public static string UserTheme
        {
            get => AppSettings.GetValueOrDefault("@UserTheme", "");
            set => AppSettings.AddOrUpdateValue("@UserTheme", value);
        }
    }
}