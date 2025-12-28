using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TMS.Core.Entities
{


public class JwtOptions
    {
        public string Audience { get; set; }
        public int Lifetime { get; set; }
        public string Issuer { get; set; }
        public string Key { get; set; }
    }

}
