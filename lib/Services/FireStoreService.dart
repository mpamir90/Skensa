import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addGuru(String uid, String namaLengkap, String namaPengguna,
      String email, String password, String noHp) async {
    await firestore.collection("Guru").doc(uid).set({
      "Nama Lengkap": namaLengkap,
      "Nama Pengguna": namaPengguna,
      "Email": email,
      "Password": password,
      "noHp": noHp,
      "Wali Kelas": null,
      "Email Verified": false,
      "Mengajar": null
    });
  }

  Future<Map<String, dynamic>> isGuru(String uid) async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection("Guru").doc(uid).get();
    print(documentSnapshot.data().toString());

    if (documentSnapshot.get("Email Verified") as bool) {
      return {"documentSnapshotGuru": documentSnapshot, "Email Verified": true};
    } else {
      return {
        "documentSnapshotGuru": documentSnapshot,
        "Email Verified": false
      };
    }
  }

  Future<void> changeEmailVerifiedGuru(String uid) async {
    await firestore
        .collection("Guru")
        .doc(uid)
        .set({"Email Verified": true}, SetOptions(merge: true));
  }

  Future<void> addSiswa(
      String uid,
      String namaLengkap,
      String namaPengguna,
      String email,
      String password,
      Map<String, dynamic> jurusan,
      Map<String, dynamic> kelas,
      String absen,
      String noHp) async {
    await firestore.collection("Siswa").doc(uid).set({
      "Nama Lengkap": namaLengkap,
      "Nama Pengguna": namaPengguna,
      "Email": email,
      "Password": password,
      "Jurusan": jurusan,
      "Kelas": kelas,
      "Absen": absen,
      "noHp": noHp,
      "Email Verified": false
    });
  }

  Future<Map<String, dynamic>> isSiswa(String uid) async {
    DocumentSnapshot siswa = await firestore.collection("Siswa").doc(uid).get();
    if (siswa.get("Email Verified")) {
      // return "Verified";
      return <String, dynamic>{
        "DocumentSnapshotSiswa": siswa,
        "Email Verified": true
      };
    } else {
      return <String, dynamic>{
        "DocumentSnapshotSiswa": siswa,
        "Email Verified": false
      };
    }
  }

  Future<void> changeEmailVerified(String uid) async {
    await firestore
        .collection("Siswa")
        .doc(uid)
        .update({"Email Verified": true});
  }

  Future<QuerySnapshot> getAllJurusan() async {
    return await firestore.collection("Jurusan").get();
  }

  Future<QuerySnapshot> getAllKelas() async {
    return await firestore.collection("Kelas").get();
  }

  Future<DocumentSnapshot> getInfoKelas(String idKelas) async {
    DocumentSnapshot querySnapshot =
        await firestore.collection("Kelas").doc(idKelas).get();
    return querySnapshot;
  }

  Future<DocumentSnapshot> getConfigPendaftaran() async {
    return await firestore.collection("Config").doc("Pendaftaran").get();
  }

  Future<void> addMataPelajaranKelas(String namaKelas, String idKelas,
      List<Map<String, dynamic>> listMataPelajaran) async {
    await firestore
        .collection("Kelas")
        .doc(idKelas)
        .update({"Mata Pelajaran": FieldValue.arrayUnion(listMataPelajaran)});

    for (var i = 0; i < listMataPelajaran.length; i++) {
      await firestore
          .collection("Guru")
          .doc(listMataPelajaran[i]["Pengajar"]["Id"])
          .update({
        "Mengajar": FieldValue.arrayUnion([
          {
            "Nama Mata Pelajaran": listMataPelajaran[i]["Nama Mata Pelajaran"],
            "Kelas": {"Nama Kelas": namaKelas, "idKelas": idKelas}
          }
        ])
      });
    }
  }

  Future<QuerySnapshot> getAllPelajaran() async {
    return await firestore.collection("MataPelajaran").get();
  }

  Future<void> addMataPelajaranGuru(String idGuru, String namaGuru,
      String mataPelajaran, List<Map<String, dynamic>> listKelas) async {
    await firestore.collection("Guru").doc(idGuru).set({
      "Mengajar": [
        {"Mata Pelajaran": mataPelajaran, "Kelas": listKelas}
      ]
    }, SetOptions(merge: true));

    for (var i = 0; i < listKelas.length; i++) {
      firestore.collection("Kelas").doc(listKelas[i]["idKelas"]).update({
        "Mata Pelajaran": FieldValue.arrayRemove([
          {
            "Nama Mata Pelajaran": "Basis Data",
            "Pengajar": {"Nama": namaGuru, "idGuru": idGuru}
          }
        ])
        // "Mata Pelajaran": [
        //   {
        //     "Pengajar": {"Nama": namaGuru, "idGuru": idGuru}
        //   }
        // ]
      });
    }
  }

  Future<QuerySnapshot> getAllGuru() async {
    return await firestore.collection("Guru").get();
  }

  Future<List<Map<String, dynamic>>> getAllKelasDiajar(
      String namaMataPelajaran, String idGuru, String namaLengkap) async {
    QuerySnapshot result = await firestore
        .collection("Kelas")
        .where("Mata Pelajaran", arrayContains: {
      "Nama Mata Pelajaran": "Basis Data",
      "Pengajar": {"Id": idGuru, "Nama Lengkap": namaLengkap}
    }).get();
    print("Jumlah Kelas Yang Tersdia: " + result.docs.length.toString());
    List<Map<String, dynamic>> allKelas = [];
    if (result.docs.length > 0) {
      for (var i = 0; i < result.docs.length; i++) {
        allKelas.add(
            {"Data": result.docs[i].data(), "Id": result.docs[i].reference.id});
      }
    }
    return allKelas;
  }

  Future<void> createKuis(
      String namaTugas,
      String namaMataPelajaran,
      Map<String, dynamic> guru,
      List<Map<String, dynamic>> kelas,
      List<Map<String, dynamic>> soal,
      String waktuKuis) async {
    await firestore.collection("Tugas").add({
      "Nama Tugas": namaTugas,
      "Nama Mata Pelajaran": namaMataPelajaran,
      "Guru": guru,
      "Tipe": "Kuis",
      "Kelas": kelas,
      "Soal": soal,
      "Waktu Kuis": waktuKuis
    });
  }

  Future<List<Map<String, dynamic>>> getTugas(
      String namaMataPelajaran, String idGuru, String namaLengkapGuru) async {
    QuerySnapshot query = await firestore
        .collection("Tugas")
        .where("Nama Mata Pelajaran", isEqualTo: namaMataPelajaran)
        .where("Guru",
            isEqualTo: {"Id": idGuru, "Nama Lengkap": namaLengkapGuru}).get();
    List<Map<String, dynamic>> result =
        query.docs.map((e) => {"Data": e.data(), "Id": e.id}).toList();
    return result;
  }

  // Master Area
  Future<List<QueryDocumentSnapshot>> getGuruKaprog() async {
    QuerySnapshot getAllGuru = await firestore
        .collection("Guru")
        .where("Email Verified", isEqualTo: true)
        .get();
    print("Guru Result : " + getAllGuru.docs.length.toString());
    List<QueryDocumentSnapshot> result = [];
    getAllGuru.docs.forEach((element) {
      if (element.data().containsKey("Kepala Program")) {
      } else {
        result.add(element);
      }
    });
    return result;
  }

  Future<void> addJurusan(String namaJurusan, String singkatan,
      String namaLengkapGuru, String uid) async {
    await firestore.collection("Jurusan").add({
      "Nama Jurusan": namaJurusan,
      "Singkatan": singkatan,
      "Kepala Program": {"Nama Lengkap": namaLengkapGuru, "uid": uid}
    });
    await firestore
        .collection("Guru")
        .doc(uid)
        .set({"Kepala Program": singkatan}, SetOptions(merge: true));
  }

  Future<List<String>> addKelas(String jurusanSingkatan, String jumlahTingkatan,
      String jumlahKelasPerTingkatan, String jurusan) async {
    List<String> result = [];
    for (var i1 = 0; i1 < int.parse(jumlahTingkatan); i1++) {
      for (var i2 = 0; i2 < int.parse(jumlahKelasPerTingkatan); i2++) {
        int perTingkatan = 1 + i2;
        int tingkatan = 10 + i1;
        await firestore.collection("Kelas").add({
          "Nama Kelas": tingkatan.toString() +
              " " +
              jurusanSingkatan +
              "-" +
              perTingkatan.toString(),
          "Wali Kelas": null,
          "Ketua Kelas": null,
          "Jurusan": jurusan,
          "Mata Pelajaran": null
        });
        result.add("Kelas : " +
            tingkatan.toString() +
            " " +
            jurusanSingkatan +
            "-" +
            perTingkatan.toString());
      }
    }
    return result;
  }

  Future<QuerySnapshot> getGuruWaliKelas() async {
    QuerySnapshot querySnapshot = await firestore
        .collection("Guru")
        .where("Wali Kelas", isEqualTo: null)
        .get();
    return querySnapshot;
  }

  Future<QuerySnapshot> getKelasForSetWaliKelas() async {
    return await firestore
        .collection("Kelas")
        .where("Wali Kelas", isEqualTo: null)
        .get();
  }

  Future<void> setWaliKelas(String idKelas, String namaKelas,
      String namaLengkapGuru, String uidGuru) async {
    await firestore.collection("Kelas").doc(idKelas).set({
      "Wali Kelas": {"Nama Lengkap": namaLengkapGuru, "uid": uidGuru}
    }, SetOptions(merge: true));
    await firestore.collection("Guru").doc(uidGuru).set({
      "Wali Kelas": {"Nama Kelas": namaKelas, "Id": idKelas}
    }, SetOptions(merge: true));
  }

  Future<void> addMataPelajaran(String namaMataPelajaran) async {
    await firestore.collection("MataPelajaran").add({
      "Nama Mata Pelajaran": namaMataPelajaran,
    });
  }
}
