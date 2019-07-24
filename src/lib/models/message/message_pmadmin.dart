/// message/pmadmin
/// const ACTION_SEND = 'send';
//  const ACTION_DELPLID = 'delplid';
//  const ACTION_DELPMID = 'delpmid';
/// 'action' = 'send';
/// 'toUid' = 0;
/// 'plid' = 0;
/// 'pmid' = 0;
/// 'msg' = 消息内容：send 时设置
/// msg 格式 {'content':'', 'type':'text' or 'image' or 'audio'}
/// private function _transMessage($msg) {
//        $msgString = '';
//        $msg['content'] = rawurldecode($msg['content']);
//        switch ($msg['type']) {
//            case 'text':
//                $msg['content'] = WebUtils::t($msg['content']);
//                $msgString .= WebUtils::transMobcentPhiz($msg['content']);
//                break;
//            case 'image': $msgString .= sprintf('[img]%s[/img]', $msg['content']); break;
//            case 'audio': $msgString .= sprintf('[url=%s]%s[/url]', $msg['content'], 'audio'); break;
//            default: break;
//        }
//        return $msgString;
//    }