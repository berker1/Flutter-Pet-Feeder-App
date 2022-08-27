import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:webview_flutter/webview_flutter.dart';

import 'GlobalValues.dart';

class WatchCameraPage extends StatefulWidget {
  const WatchCameraPage({Key? key}) : super(key: key);

  @override
  _WatchCameraPageState createState() => _WatchCameraPageState();
}

class _WatchCameraPageState extends State<WatchCameraPage> {

  var new_root = "";

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> rootUser() async{
    var sp = await SharedPreferences.getInstance();
    String? root = sp.getString("qrCode1");
    new_root = root!;
  }

  var base64String = ""; //= "data:image/jpeg;base64,%2F9j%2F4AAQSkZJRgABAQEAAAAAAAD%2F2wBDAAoHCAkIBgoJCAkLCwoMDxkQDw4ODx8WFxIZJCAmJiQgIyIoLToxKCs2KyIjMkQzNjs9QEFAJzBHTEY%2FSzo%2FQD7%2F2wBDAQsLCw8NDx0QEB0%2BKSMpPj4%2BPj4%2BPj4%2BPj4%2BPj4%2BPj4%2BPj4%2BPj4%2BPj4%2BPj4%2BPj4%2BPj4%2BPj4%2BPj4%2BPj4%2BPj4%2BPj7%2FxAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv%2FxAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5%2Bjp6vHy8%2FT19vf4%2Bfr%2FxAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv%2FxAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4%2BTl5ufo6ery8%2FT19vf4%2Bfr%2FwAARCADwAUADASEAAhEBAxEB%2F9oADAMBAAIRAxEAPwDge49MZzSd6pswcUhOO1FF7DRTnt8rujHyjrzRY3UlheLMqq23qrDOanm6M00lud3p11bavG00FuII0wHQ8tmt6OCED%2FVLXXzGfIti3HDFs%2F1S08Qxf88lpoPZod5MX%2FPJaTyYc%2F6padxciApbpy6xr9TVSa90%2BLssnslIXs0UptR3qfs9iij%2B8TmsDUtUtYV3XLCVs42RkZo5tClSic5d6o1037qNYoug%2FvGstv8AWVzX1NeUI8b8dKsSqqnrzUOVmZvexXf9PrTqLO5VrIixS4x0od2UthKOtMTEwPWkPNNsrQSkPJoW5IUUmtQsANJTe47C0lIewhxSGkC1EpKYjbNymRkMKX7TETxn8qXxMiSdxd6ddyj6mmmaMc%2BYuPrQ0K2gzz4%2Bx%2FKoXiWeRRAMyenrTsy1oxdNvZdOv0uoPvqcbT39q9S0m%2Ft9UsPtNqenEkZ6xmrjIJbmrH9ys278QaZaOUkuo949WxW4jJufGtopPl7T%2FufNWbN4zEgOPtbfQCOsnV7D5Cl%2FwkRk5Fpn%2FfmJqtda7fbMw%2BXD9Bmo9rqS3rYx7q7uro5uZ3fHvik2%2FugaiU7suIinpilYDdRuMj6MeacvJzRcjzEbmg8dDkULcTI880tO1ihD7U3pSKEooBiUlNy0F1uFGakYuDt3e%2BKSmxITmjB6Ur2GIKSqCwGkoAvZ%2BUUzd14phLcZuyelA65pMEOrS0L%2FAJDtj6eeo%2FWnBvlC6udNr3h0X8TXdih%2B2quWXd%2Fra5LSNVutKvPtNucN0eNuje1D0Yro0NR8Qahqjfvp%2FKjx%2Fqozis35c%2FNuP86idWRUdBh4puagroWYm%2FddqiuG4Apweph1IDz61NDzG1aF7BEPm9Ke%2FwB6pKRGyHrTwAI%2BnNDMpPoQnrSVaGNxTjwOKVmy0MpvekAUlNxASikIO9JQwG9%2BadTYxKTNMkSlzSsVYbRRITLrdB9Kibr%2BNLl5ZDXKJ7U%2FOKAsL2q1YSGPULWTukyHn60bAehz61plqzn7UJMHpEcmuD8QXMOpam93bwrCG%2B8o7n1rV25SUtbmWpINTBveud7lX1Id7GjtlulVsU2KJGXvxUu4umWNMiww8tVm1%2F5ar9DQx%2FZFj%2F4%2BP9nGKmZKzNYEG75TSAfLWnQ5bakJ4NJTWxoNJ%2BannkcUwI6bU9BsKXFV0EFJS2GhuKOhqZXEN70VURi0lArB2pKXQsbSGqvYkuTHkDPGKj5wanXYGgpy8cUbkPUf97604CmPpYd8oPSndaJagQTJjlajU%2FLSWpQY6UjHmnJpjktB8frUq85NInYb1NWbAfv5f93%2BtPYY%2B3X%2FAEnA96sOMNzWcmb09yrCnXNIeFwas5JPWxXam07lDadk%2BtFyrjDSU7CFFIOvFIewtIKASCkqLgxtFUAlFABRQUMNIKGSWSemaYarfcObUTnvTh9aWliUO5xQGINNPQYu45pQxpXAUknrmomX8KfQY%2FPFRe1RHcbJm%2BWPHrUka%2FuRTF0FA5qzYD97OcgYTNGgmT2cf%2FEwx2wasXkW2b6ily6XOiO5UXgmoJfumn5HFJ6lbpRTaLuNHvS01qhjTTRTAdSVJXqIKdSerBbCHGKbSDoJRVAJiile6GFIaOYY003FNE3LBwWzimdadxWCnVL1GkLj60lVoA%2BmjipbSQx1HagFqRkYqSNcfOenalcTG%2FMV5q3EP9HFF1ckMVd0hB%2Fpr4%2B6goKW5c0dC%2BoAf7Jq3fQbr%2FkfLto%2F5dnSl75mzQ7ZD0z7VUnTjFN73OCp7tRlUjmmNTLTGU4VS2KGUneo3GhaKYCU6k7FIQ9aa1JEjaKpgKOaKkBKYaaATvQaPMRMecYptNeZTd9QzS9aTC472NFCWhN9Rcn%2FAGf60tVyDuAp1RsERsgHamfwY7UQvuwe4o%2B4BWjCv%2BjqfamkKew3HBrT0SINYanJ%2FwAB%2FSjYdJl%2FQof3skuO3H8qtahxeQj%2FAGaqGx1x%2FiGLe8Xj%2Bn%2F1qrSLSZ59de%2ByietMap8ikR04Dir2VihjU3miw0hfajtSAbRSaC4U2jlAKTvQA7tSUWGJ2ptCQhKTNN3EWCOKZ7YGPpSkEhKXvRcGOHSkFOLDlH0oqmIPwpy1kVHck25cDtVeQYcinGWlge4uPkrbihP2TPouKYmVsfKa19AGNEv2I6zD%2BVF77lUdzT0eMi2yc9cc1DqEwOqxxdwuatbHVB%2FvihfqPOzxVB%2BR61E2cWI%2FiMpM3NQvUomwwZp26rZYxuT0pO9JMYUnbinsIBQaiw0NpKq4hKKYC0lKwwppFCASkp3CxaPSosZFLpzByigUoo3QB%2BFOoFcBjFL2oTuxhniihjiWo%2F4e27Bqozb3Y470o7EW94FbHNdaltt0IS%2BtXHYtIyMcH2rU0fjw2ygcyTnNTEqivfN%2FT4%2FLtU7cc1y1vMbjXZJPVjV%2FZNqX8Um1U4kCge9ZgbJxUSOTFfxWVpOtQtRFGQzntTgBR5GgGmc7qNi0H40GgYlBpBYSm96a8wCk7UNisFHagApKBiYpKdkxG75Sj%2BAflUH2aPG0DGe9JqysZ8%2BpRlR4n%2BbpVm38qVMGPDjv60norlS12JHtlK8fKap48t8TocU7XRMS2kEDRhgG%2FE9Kd9mhC9HP1ahWJ5nsH2ePsD%2BdRSQkcqpNKxtCVtR%2FKL5n92LFUfeheQLuOQZdR6mvQryHytAZV6IgxVxTch82hzEg%2Fdk1p6ON2nQJ%2FtMf1NDVtCqW5tXr%2FZ9IuJv7qVxmk8Xi%2FwA%2Fxqexth%2FjNDVBiUZ7rWX3oa6nJi%2F4rIX5qBs560ERIxxTx0o8ywJpp607DQgpDSsMBRUgJSdapgFJQHmFBpMBKSgBKKd7MGzoW4qPFJpox9BrJGy%2FMM1nTwNBh1fGTjg80tXuXF9C3b3Qm4cBT6VM0aPGVfofenG6Iekii0b2rFl6Yzk96uQzLNwDyOtTuyvMkxSHmrSuK5WvG2RbFJy%2FWqHHNBrF6FuyQS38I55kHSvRdWTbpjgfhWkL3H0OSnXNu22t3S4NkKrjgDI%2FGod%2BY1irRbI%2FFc%2Fk6OsGeZnHH0rnNLO69RfWlNXHQfvmnq%2B1VTHU1jMacjDFfxWQlqhc1C1M0xlHFV0NOgNik4pXEhaU%2FdzQNDaQ0ge4YpKYw%2FGimxXEpKQwptNIQUho3KR0ZFNK8mnc50IBkc03bujw4BB6ikgZnXFs8T7lwy9eO1S2119yObKnp0pXLfvF4qG%2BUjI96zrmB7dvNh6evpQtWGxZt7gS8Hhv50%2BVhGNx6dKEKxll3f7xzimVVi46Gn4cTzNdt1Prur0PVlxYKKqG5Vzn4bYPIBs4rchXCk%2F3qU9ZXNv%2BXZyPiyXfq6x54iT9ap6Spe7GFzgVMtSaHxGhrG7dH6baxy3FEtjPFL96QZ5ppOaDEj70GqL6AaTvzSAKU0rDuITTaACkoGxaKHqAUVIxKSmAmaTvTA6U8io%2BevamlZHN5i0tFuo2xvbFULu2JYugzx0ApdS4sbbXZT5JPu9iK0PvL2INAS2M66gMUnmxlvX6Uslx51lt%2FwCWmRmmNO5W60lTvsV1sb3gyMtrxYdoyK77W0P2VRtNaQ0GZVvHsG4itMx4IUelR8UjaWkLHn%2Bu2d1HqkrzQv8AOcgjnNdN4f0023h%2BWZ48SyAnJPtWko2FSZi6zu%2BUv9KxG6VmyMV%2FFIB1ob2pqxiNpKCgPSkphcBRUgNpM1VkAUVIBS0NFWCm0INRaSk2A2lp3A6M03PNPeOhjLXUdmgniheYtwI%2FKhj82doX2zmjl7A420KVxZ%2BapKcSfzqpDNJbPht2z%2B7S8i4u6sakcqyw%2BYh471n3Vr5fMX3f5UwjoyDGFFNPWg06lixvJ7KRpLWVonIxuWpnvr6d8yX1y7e8hqoy0J6nZw7oLG3jkcu8p6k%2BtdA4xM3%2ByMVMPiOmsZcI%2B2a%2BvAZBXQ6pEg05wihfl7VvV3MqZ5xroOxDWC1c9gxPxkVIaLGfkNpKZSEopLYVgoNLcHsJmm5p2sJBSUMYlLTY7i0ZqdwE7UUMBKKY0dDn86TtVPsjmQHoKGpWKQ%2FOTzS8UAw7VBPbRzD5uG7N6UbsHoZmJrSX0P6Gr8FxHcptK4b0NMt7XK1yAGwvQVWPWp6jiOaJlq7o9v8Aa9Vhh5xnJ%2BmaJ6IunrM7lP3ut2iY4TmtiU4jd%2FeqpblVin4Xj8y6kmx9K6HU1zZv%2Fu1tPcmGh5rrkf7gnd%2Fy1%2Fxrnn%2B7XO9y8X8ZXoNBgM70pqrlCE0nepGLTWpoQlIaYhKQ1IxKdTGL2pKXkAGigBKSkM6HPNNqjFgOlLS21I6jgfelzRfUaHDJ6CkPTmnzX0ERuiumHHBqhcWLJzH8y%2FyqdbmkGNl5YHp8tEcf8TDgVUFqO9iN5M8sa6fwnbrtmu3%2B99xf60qhvQjZ3On0tM6hNKf4EwKk1aTZp%2Fu3NbUtyKjNLw1beXYAkctWpfLm0YUgR5prSH7O%2Fp5mf51zMvTisWzTFR1K3fpRTuYCUVXNdDENFTzFRG0namT1DrSd6YkIeaKVx7iUVTY9RaKyCwUhPNUAUlTsxm%2BaGqpLoYCc9KXoOaAAUopqwD8mila7BaDaXrRsMzp%2BZ9op8vy%2FuxWiXUq1zu%2Fh9o9ncaTLcXFvFI7HAYrXoVppFnHpXltEGOSc1zS%2BM6qXxWK7aZaKreXEFJ61x2sqJtQitF9ea7I%2B7qXiqXLqdpZWP2eziXd%2FDRfw%2FwCjn6VjGVzli9Ty3WQf369g1cxNxkUHRiuhWPSk7UjlEU0p6ULQpDKKbC4lJSEFNNABRQIKSn0GFBpDuAooYXCkoA3uvNKeBk05%2FEYPcarA9KWl1AKUdKLjuhQc0uaaSuAZpKQyqPlLufpVdvmetPsFx%2BI9d8FJ5Phq1VeM812Ub5tW%2Blcn2jop%2FwAQo3Mm1DXE6b%2Fp3ipm7Lx%2FKu37DN8az0Fz8lV7w%2F6IfpXPTOCJ5drC5kuffNclP1qttToxPQqmko9DEbTs8UxXGHpSUDE7UnFGwBSUCFpKQBSd6BiGijmJsFGaCrh1pKVr6BY3f0oFNy1MG9RPrRzQmUO%2FiNLn3zVITXUFpanmBCr0ppOBz0ojZuwbFaXjiq5B7dauo%2BxdM9q0NPK0e0X%2FAGK243%2FcsPauRbnTS%2BMxtbuhDZSOTjisLwQN8zTN97qa7qn8EvF%2FEdw7%2FLUU3Nma56ZxxPNdbQ%2BfKB%2BFcdP3qpo6sRsipSUHMNopgBpKRSCmmjfQTEoo8gQlFFgCkoYdANFGwX0CijQYlFD1A3KPrQ30MroQZBz0pfrTAKeenNIBO1KTxRbW4kHPqKCdoyKpfEG5Rq5pNp9q1GOPnb1c%2BgpTfU2prWx7DbYSJEAwAo4q15m2J%2FpXN1NqfxnH%2BK7zMPkj%2BIipfBLf60f3a7a2lIVfWTOuMnFLIf8ARDXPTMUeca2f9Pk21xsvSrZ0Yj4UVjSUM5xtJTC46kpDGmkpiCkoASilcYlHShgFJQIWjPFIYUhoC5s7s0nSn1sjN7js04c037qEITzS0dCbBmncY6ilcBKZJ2HqaqMhkH8P0rpbELplqu8fPJIvHv2qZXaudVLuekD5Wx6Cm3TbLWQ%2B1Yx1aFF6nBzv%2FaOtf7CjrW94a%2Fdz3Y9OK6sU%2Fsly%2BC5v%2BZVmU5s%2FrWVIwPOdWbF7NXIT1bOqv8KKp602pbOXoFFAMKQ0dR3EpKEIQ0lPyAKKLAJRQ2AUhpAFHSjqAlJQxm0TSUcupj1G5I604PxVONyrC54zilDZ9PzrLUQbueaN1Vyi0FzTcZcn0FXT91DWpb0yBVj%2B13A%2FdDlPfFNtbn7f4msmc%2FL5wG3%2BtS%2Fh0OpaQseto%2B5jVPXZxBo871FNe%2BjI5bw9FvaScr1PFa3h4%2Fu7t%2FWatcR8R0S%2FhGturSl%2F49QPaopHOeda1%2FyEmrkrjmqZ0V%2FgRVNN70mcolHanYBaShofQSmmgSYGkNNjCkpC5hKWkMKKBoKbRazAQ0lMDb603tRuQu4CjtxU9QE%2BlFNMlingZ7Cnd8GklbUSiIOgH4VYtI7Q3zi6lPkr6D71VeyZpBWZWvdR%2B1bY4k8uLsBXXeGdPh0RYLm%2B%2FwCQjeP5cC%2F3AaVtDSep2kH3a5vxjeYgS0X7zvnrRQ%2BO5Nh2mW7W2nICO2TVjRAV08%2F7T0VdWdVZWgX8%2FMM1rT%2F6j8KKZyHA69xqA9cH%2BlcfeD5sjpTZ1Vv4aKZpvShM4xKSm2MWilcYU09KQxtJTEBopMQnejvQ9ih1JQAUhoAbSUdSWbJzSUNi%2B1YXtSUREFLQw8hO%2FU0v40dCRjyYqE7t64zjrxR9mxZ0Ol6XDodkurasga6Yf6LZ5%2F8AHqTRJrvVvG1lc3b72EnmYz90CiX8Oxa3PSYztXmuJvMaj4tCAAhfUdelVRjo2VT%2FAIiOueDZbED0o0628uwjXvz%2FADqJnTitiV0%2FeJn1rRn%2B7VQ2ONHAeJxi%2BT6H%2Blcdd5BxnjripludVT%2BEUqQnJpnMFJTJCkpDFzTc0xMSk70xoSipsIKKb0KClpCEpKBjaSnsgNo%2FdptJWRm0LR9aBa2CijqKwVDLNjgdPWqfYfKRpG0nzYO31rc0yWx0%2B3e%2BnDTXgOIIf4R71pHzAzJ76a8uWnvG3TN1Ndb4Dt83N5dnH7pdgOO7VjUki0dTeT%2BRYTSHstYHgm3NzeTX0nJz37VrTf7s0ofxDtJIxtp1sn7vHpWVQ6MYR3KYmhP%2B3VmccUUjjR594t%2F5CUQH9xv6Vx1796h%2FEddT%2BCU6bTOUMUUbiEoNAxKaaYB2pKkVgpKYxKUc0SAWipASkNMBneii4zaIplUR6BTsVNtRNidVBx1pCyjrQJlcyE0CImNi35UPuaJHbeKVtbgafKl3B5dvbCNYk61yJPyNV390j7Y2SPB9q73wFF5Xh68IOfMugfyWs38JoiXxbcCLRjF3lbGPatXwjF5WhCSQgvI24kVf2EaYde%2Fc2C4xT7U%2FLUVTbGBcjO0%2Bhp5NOnscaOA8YjZfwH1Df0rjLtt3NE9zsb%2FclKm96e5yDjTaS0C4UflQA2kNAAaQUAFJQAYpKBC0UDENNpAJRTGbmDTRQ%2BxIUZwKLWIsiu0o7VEuZW4p9CywkAHPepdvFJXMxB645pOx4zmnbdjHHBWvQvCClPC8P%2B1LIf1qJGvQwPF1wbjVYrRP4V%2FU4rvbGMW%2Bkwxf3VrSWyNKHxC7qkgk4qKp0YvYc0lPRtwp0jhRxPjb%2FXwZ9TXEXnrRvM6v%2BXRTpKo5WxOKSkNC0nepEJSHmq6jD6GkpeYhKKbYxabSAKSnuAUlIApKLAbxIUckYqJ7lM%2BtXuzNIrvck%2FdGKZmSX7uTmpqFrTcnjtf4pWGT%2FCO1WAu1QBwKSM3K7DFJ2qrBa4mKY%2FQ047C6kkSmQ9PevSNBUReH7RPqf%2FHqKmyNvsnJFVvPGPyjOZP5V6JczBI8Z5NKp8ZrQ3RU8%2FNLbvmTFTU2OnFfCWqmhpUzzzkfGY4jIPRq4O5HFU9JHT%2Fy7KRooZgGTng4ptMAozzU2uMbQaACmmgQUtFg6CUlPoAp5pKXQQneimMSkpX1Bmj5Uz7flHPuKctkT96QfhVbbCuiZLWJMcE%2FWrHYCp82ZyfcMUuKokSginYd9BNp25Ktj1xUL8DOSfrT5fcYQkrl21TEaeuK72J%2FI8OQv0KQ5pdkau1jk%2FBmZddkmHPU%2FrXb3Fs8vz7qir%2FGNaHxIYsDUlsCLoiipsdOJ%2BE0hG1TRxlM0qZ55yHjUhYV%2BtcFdGqfxHWn%2B6KRpOpp3OUTjvRSKHGm96SJixtLTaLG0UW0ENpaGDAHikpWC2gUlDGFHWgVxKSkM%2F%2FZ";
  //var refBase64 = FirebaseDatabase.instance.ref().child("user1/esp32-cam"); //change
  var refBase64 = FirebaseDatabase.instance.ref(); //change

  Future<void> base64Image() async{
      refBase64.child(new_root).child("esp32-cam").onValue.listen((event) {
      //refBase64.child("user1").child("esp32-cam").onValue.listen((event) {
      var data = event.snapshot.value as String;
      base64String = data;
      convert();
      print("try3 $base64String");
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    //convert();
    rootUser();
    super.initState();
  }

  Future<void> convert() async{
    if(base64String != ""){
      base64String = base64String.split(",").last;
      base64String = base64String.replaceAll('%2F', '/');
      base64String = base64String.replaceAll('%2B', '+');
      print(base64String);
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        appBar: AppBar(
          leading: IconButton(
            color: Colors.transparent,
            icon: Icon(Icons.arrow_back),
            onPressed: (){},
          ),
          backgroundColor: Colors.lightBlue.shade100,
          title: Text('System Kamera', style: TextStyle(color:Colors.lightBlue.shade900 ),),
          centerTitle: true,
        ),
        body: Container(
          alignment: Alignment.center,
          color: Colors.blueGrey.shade900,
              child:
                  Column(
                    children: [
                      SizedBox(height: 80,),
                      base64String != "" ?
                      Text("Für Ein Neues Foto Klicken Sie Wieder Button", style: TextStyle(fontSize: 24,
                          color: Colors.white54, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)
                      :Text("Zum Foto Machen                                            "
                          "Klicken Sie Camera Icon", style: TextStyle(fontSize: 24,
                          color: Colors.white54, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),

                      SizedBox(height: 60,),
                        base64String != "" ?
                        Image.memory(base64Decode(base64String))
                            :GestureDetector( onTap: (){
                              base64Image();
                        },
                            child: Icon(Icons.camera_alt, color: Colors.blueGrey.shade50, size: 300,)),
                      SizedBox(height: 60,),

                      base64String != "" ?
                          Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox( width: 120, height: 50,
                                child: ElevatedButton(
                                    onPressed: (){
                                      convert();
                                      saveImage(base64Decode(base64String));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.lightBlue.shade900,
                                      shadowColor: Colors.lightBlue.shade300,
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        side: BorderSide(color: Colors.black),
                                      ),
                                    ),
                                    child: Text("Speichern") ),
                              ),
                              SizedBox( width: 120, height: 50,
                                child: ElevatedButton(
                                    onPressed: (){
                                      var controlParameter = HashMap<String, dynamic>();
                                      controlParameter["controlCam32"] = 1;
                                      refBase64.child(new_root).update(controlParameter);
                                      GlobalValues.showSnackbar(_scaffoldKey, "Foto wird in 8 Sekunden laden", 8);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.lightBlue.shade900,
                                      shadowColor: Colors.lightBlue.shade300,
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        side: BorderSide(color: Colors.black),
                                      ),
                                    ),
                                    child: Text("Wieder") ),
                              ),
                            ],
                          )
                          : Center(),
                    ],
                  )
          )
        );
  }


  Future<String> saveImage(Uint8List bytes) async{
    await [Permission.storage].request();

    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '_')
        .replaceAll(':', '_');
    final name = 'screenshot_$time';
    final result = await ImageGallerySaver.saveImage(bytes, name: name);

    print(name);
    return result['filePath'];
  }

}
