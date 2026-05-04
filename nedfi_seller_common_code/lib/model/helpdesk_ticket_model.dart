class HelpDeskTicketModel {
  int? success;
  int? totalTickets;
  int? pages;
  int? replyFlag;
  List<Tickets>? tickets;
  List<TicketsCount>? ticketsCount;

  HelpDeskTicketModel({this.success, this.totalTickets, this.pages, this.tickets, this.ticketsCount});

  HelpDeskTicketModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    totalTickets = json['total_tickets'];
    pages = json['pages'];
    replyFlag = json['reply_flag'];
    if (json['tickets'] != null) {
      tickets = <Tickets>[];
      json['tickets'].forEach((v) {
        tickets!.add(Tickets.fromJson(v));
      });
    }
    if (json['tickets_count'] != null) {
      ticketsCount = <TicketsCount>[];
      json['tickets_count'].forEach((v) {
        ticketsCount!.add(TicketsCount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['total_tickets'] = totalTickets;
    data['pages'] = pages;
    data['reply_flag'] = replyFlag;
    if (tickets != null) {
      data['tickets'] = tickets!.map((v) => v.toJson()).toList();
    }
    if (ticketsCount != null) {
      data['tickets_count'] = ticketsCount!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tickets {
  String? id;
  String? userId;
  String? departmentId;
  String? subject;
  String? date;
  String? lastUpdate;
  String? status;
  String? replies;
  String? userFullname;
  String? departmentName;
  String? description;
  String? msgId;
  String? ticketReopenDate;
  String? ticketResolveDate;
  String? staffId;
  String? msgDate;
  String? statusClass;
  String? statusName;

  Tickets(
      {this.id,
      this.userId,
      this.departmentId,
      this.subject,
      this.date,
      this.lastUpdate,
      this.status,
      this.replies,
      this.userFullname,
      this.departmentName,
      this.description,
      this.msgId,
      this.ticketReopenDate,
      this.ticketResolveDate,
      this.staffId,
      this.msgDate,
      this.statusClass,
      this.statusName});

  Tickets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    departmentId = json['department_id'];
    subject = json['subject'];
    date = json['date'];
    lastUpdate = json['last_update'];
    status = json['status'];
    replies = json['replies'];
    userFullname = json['user_fullname'];
    departmentName = json['department_name'];
    description = json['description'];
    msgId = json['msg_id'];
    ticketReopenDate = json['ticket_reopen_date'];
    ticketResolveDate = json['ticket_resolve_date'];
    staffId = json['staff_id'];
    msgDate = json['msg_date'];
    statusClass = json['statusClass'];
    statusName = json['statusName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['department_id'] = departmentId;
    data['subject'] = subject;
    data['date'] = date;
    data['last_update'] = lastUpdate;
    data['status'] = status;
    data['replies'] = replies;
    data['user_fullname'] = userFullname;
    data['department_name'] = departmentName;
    data['description'] = description;
    data['msg_id'] = msgId;
    data['ticket_reopen_date'] = ticketReopenDate;
    data['ticket_resolve_date'] = ticketResolveDate;
    data['staff_id'] = staffId;
    data['msg_date'] = msgDate;
    data['statusClass'] = statusClass;
    data['statusName'] = statusName;
    return data;
  }
}

class TicketsCount {
  String? statusName;
  String? status;
  String? statusId;

  TicketsCount({this.statusName, this.status, this.statusId});

  TicketsCount.fromJson(Map<String, dynamic> json) {
    statusName = json['status_name'];
    status = json['status'];
    statusId = json['status_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_name'] = statusName;
    data['status'] = status;
    data['status_id'] = statusId;
    return data;
  }
}

class Attachment {
  String? id;
  String? name;
  String? filetype;
  String? msgId;
  String? size;
  String? enc;

  Attachment({this.id, this.name, this.filetype, this.msgId, this.size, this.enc});

  Attachment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    filetype = json['filetype'];
    msgId = json['msg_id'];
    size = json['size'];
    enc = json['enc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['filetype'] = filetype;
    data['msg_id'] = msgId;
    data['size'] = size;
    data['enc'] = enc;
    return data;
  }
}
