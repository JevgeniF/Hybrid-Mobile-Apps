using System.Linq;

namespace Todorin.Models
{
    public class ErrorMessages
    {
        private string[] Messages { get; set; }


        public override string ToString()
        {
            return Messages.Aggregate("", (current, message) => current + message + "\n");
        }
    }
}