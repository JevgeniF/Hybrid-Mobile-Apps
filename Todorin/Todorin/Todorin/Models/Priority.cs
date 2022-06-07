namespace Todorin.Models
{
    public class Priority
    {
        public Priority()
        {
            PrioritySort = 0;
        }

        public string AppUserId { get; set; }
        public string PriorityName { get; set; }
        public int PrioritySort { get; set; }
        public string SyncDt { get; set; }
        public string Id { get; set; }
    }
}