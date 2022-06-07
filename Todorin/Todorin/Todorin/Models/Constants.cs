using Xamarin.Forms;

namespace Todorin.Models
{
    public static class Constants
    {
        //------------------- API LINKS ---------------------
        private const string ApiUrl = "https://taltech.akaver.com/api/v1/";
        public const string RegisterUrl = ApiUrl + "Account/Register";
        public const string LoginUrl = ApiUrl + "Account/Login";
        public const string CategoriesUrl = ApiUrl + "ToDoCategories/";
        public const string TasksUrl = ApiUrl + "ToDoTasks/";
        public const string PrioritiesUrl = ApiUrl + "ToDoPriorities/";

        //------------------- REGEX PATTERNS ---------------------
        public const string RegexEmailPattern = "\\w+([\\.-]?\\w+)*@\\w+([\\.-]?\\w+)*(\\.\\w\\w+)+$";

        public const string RegexPasswordPattern =
            "^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\\d]){1,})(?=(.*[\\W]){1,})(?!.*\\s).{6,}$";

        //------------------- MAIN COLORS ---------------------
        public static Color CDarkPrimaryColor = Color.FromHex("607D8B");
        public static Color CLightPrimaryColor = Color.FromHex("2196F3");
    }
}